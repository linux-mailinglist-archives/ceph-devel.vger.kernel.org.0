Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F70347097
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 05:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhCXEzU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 00:55:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232693AbhCXEyr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 00:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616561686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0N617PbnRNzEzqXg6v1e+pmELWky6SIdDK6sK5M+q8U=;
        b=ffPmoHGefRSdJx8DtBfBjN9ghrch7eHHqRNt8rI8bcLeQ6U5iBBio47CTTFW0qF1EpNhZe
        iWt85+d9GeSivf+gzheDiL/n1wpo1KO+G3xeN8z3krHSIu9vZwD1jWOkezOiiZ4BeiVn8H
        prqKNqeSmYQLG0+PbhHbPtU9GlcybOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-CCu_XvtONNWQkP0jLbsfvQ-1; Wed, 24 Mar 2021 00:54:42 -0400
X-MC-Unique: CCu_XvtONNWQkP0jLbsfvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 058E21005D57;
        Wed, 24 Mar 2021 04:54:41 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E61B89CA0;
        Wed, 24 Mar 2021 04:54:38 +0000 (UTC)
Subject: Re: [PATCH] ceph: send opened files/pinned caps/opened inodes metrics
 to MDS daemon
To:     Jeff Layton <jlayton@kernel.org>
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
References: <20201126034743.1151342-1-xiubli@redhat.com>
 <c9ec3257-6067-68a6-e10c-802141e9227b@redhat.com>
 <5c1461d4f7c03f226ed2458f491885cfe9b44841.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5f3ce92d-8c1c-d8de-1a10-bf30dc2800af@redhat.com>
Date:   Wed, 24 Mar 2021 12:54:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <5c1461d4f7c03f226ed2458f491885cfe9b44841.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/24 12:53, Xiubo Li wrote:

[...]

> > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > index 5ec94bd4c1de..306bd599d940 100644
> > --- a/fs/ceph/metric.c
> > +++ b/fs/ceph/metric.c
> > @@ -17,6 +17,9 @@ static bool ceph_mdsc_send_metrics(struct 
> ceph_mds_client *mdsc,
> >      struct ceph_metric_write_latency *write;
> >      struct ceph_metric_metadata_latency *meta;
> >      struct ceph_metric_dlease *dlease;
> > +    struct ceph_opened_files *files;
> > +    struct ceph_pinned_icaps *icaps;
> > +    struct ceph_opened_inodes *inodes;
> >      struct ceph_client_metric *m = &mdsc->metric;
> >      u64 nr_caps = atomic64_read(&m->total_caps);
> >      struct ceph_msg *msg;
> > @@ -26,7 +29,8 @@ static bool ceph_mdsc_send_metrics(struct 
> ceph_mds_client *mdsc,
> >      s32 len;
> >
> >      len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + 
> sizeof(*write)
> > -          + sizeof(*meta) + sizeof(*dlease);
> > +          + sizeof(*meta) + sizeof(*dlease) + sizeof(files) + 
> sizeof(icaps)
> > +          + sizeof(inodes);
> >
>
> These sizeof values look wrong. The buffer requires more than pointers
> for those. You probably want:
>
>  ... + sizeof(*files) + sizeof(*icaps) + sizeof(*inodes);
>
Yeah, will fix it.

Thanks


