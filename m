Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D8148D371
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 09:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiAMIMX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 03:12:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbiAMIMX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 03:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642061542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/h04YPXuCCdHu82aOXGGdt3/+F4mEICiTv9gd6dIDE=;
        b=Gnjyw4Thz8JUKOQkioifv0mJyYFXO2V1/j97sJV1GwP2tfYzPuopm4BbfRKVEB/Bd89SpP
        8llGCic66A2KgnMcu5tRMdM0UCSaXrYKE3TnpH39nwtgFC45qICf+UBPNxvf47T+iHkwkL
        QcEv6PQ14ypgU2/bvnb5OIQ29E7v2Hw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-eu_uv0VGPTWnSmztqgbrJQ-1; Thu, 13 Jan 2022 03:12:19 -0500
X-MC-Unique: eu_uv0VGPTWnSmztqgbrJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22CC4100C663;
        Thu, 13 Jan 2022 08:12:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2FF91059163;
        Thu, 13 Jan 2022 08:12:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
References: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     dhowells@redhat.com, jlayton@kernel.org, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: [PATCH] netfs: make ops->init_rreq() optional
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1482156.1642061523.1@warthog.procyon.org.uk>
Date:   Thu, 13 Jan 2022 08:12:03 +0000
Message-ID: <1482157.1642061523@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> ---
> There's already upper fs implementing empty .init_rreq() callback, and
> thus make it optional.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Btw, everything after the first "---" line will get stripped by patch
importation, so your S-o-b needs to be above that.

David

