Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC9215FB8A
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Feb 2020 01:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBOAkA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 19:40:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725924AbgBOAkA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 19:40:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581727199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mj5GBfrf2enyx1nwf9s5llgxiUKqTmPSO6HYbFfOFhE=;
        b=NnzvjWpKNx/28/TqfTWkfVdwtRvE7BCYBqmv2IWQjoOgQl3nA7GVaXHV7N5ibyCnnuba1t
        wXpkcd3jaLuB+20Joqr4QFioTsdkmjEYIkKl4r4W88i2LiPtfePpa963HORMeMntgrnCE+
        dK/Cth0rVWf5wH3toVnA7T6BIHC2VnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-KxDuzDFSMsWkFaUB_g3oiQ-1; Fri, 14 Feb 2020 19:39:52 -0500
X-MC-Unique: KxDuzDFSMsWkFaUB_g3oiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0109F100550E;
        Sat, 15 Feb 2020 00:39:51 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A6283865;
        Sat, 15 Feb 2020 00:39:45 +0000 (UTC)
Subject: Re: [PATCH v6 0/9] ceph: add perf metrics support
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200210053407.37237-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5729f4f1-caeb-84fb-4df3-dc623ee15ba3@redhat.com>
Date:   Sat, 15 Feb 2020 08:39:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200210053407.37237-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/10 13:33, xiubli@redhat.com wrote:
>
> Xiubo Li (9):
>    ceph: add global dentry lease metric support
>    ceph: add caps perf metric for each session
>    ceph: add global read latency metric support
>    ceph: add global write latency metric support
>    ceph: add global metadata perf metric support

Hi Jeff, Ilya

Currently the corresponding PR in the ceph is still not merged, so the 
following 4 patches we could ignore for now. And I will address the new 
comments and post them after that PR get merged.

The above 5 ones are only kclient concerned, if the above is okay could 
we split this series and test/merge them ?

Thanks

BRs

Xiubo


>    ceph: periodically send perf metrics to ceph
>    ceph: add CEPH_DEFINE_RW_FUNC helper support
>    ceph: add reset metrics support
>    ceph: send client provided metric flags in client metadata
>
>   fs/ceph/acl.c                   |   2 +
>   fs/ceph/addr.c                  |  13 ++
>   fs/ceph/caps.c                  |  29 +++
>   fs/ceph/debugfs.c               | 107 ++++++++-
>   fs/ceph/dir.c                   |  25 ++-
>   fs/ceph/file.c                  |  22 ++
>   fs/ceph/mds_client.c            | 381 +++++++++++++++++++++++++++++---
>   fs/ceph/mds_client.h            |   6 +
>   fs/ceph/metric.h                | 155 +++++++++++++
>   fs/ceph/quota.c                 |   9 +-
>   fs/ceph/super.c                 |   4 +
>   fs/ceph/super.h                 |  11 +
>   fs/ceph/xattr.c                 |  17 +-
>   include/linux/ceph/ceph_fs.h    |   1 +
>   include/linux/ceph/debugfs.h    |  14 ++
>   include/linux/ceph/osd_client.h |   1 +
>   net/ceph/osd_client.c           |   2 +
>   17 files changed, 759 insertions(+), 40 deletions(-)
>   create mode 100644 fs/ceph/metric.h
>

