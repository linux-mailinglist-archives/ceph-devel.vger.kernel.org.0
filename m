Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2621048D370
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 09:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiAMIKl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 03:10:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231493AbiAMIKl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 03:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642061440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksCei4fXoXtJYe9GluAWiRqqZMSIHo6FhczISgMfG5I=;
        b=ClJFuA+WIUhhXtrpRnY+CH/aVBSlmfyro5h40v0PcQiXWb9FFoBqVPYW/+xsLBTJ0jUKwP
        0EkMa0v87Po1g1dzJcBTzoqwn554TCtizAhCXH6LH0PICAPwCVlDSFtEvEEWX+xVmF4Jgv
        nKF2ntrRt1qH72Kw+PFlZStpb9dMToY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-aH1Xi3GvOk6zEvSNn6z4ZA-1; Thu, 13 Jan 2022 03:10:36 -0500
X-MC-Unique: aH1Xi3GvOk6zEvSNn6z4ZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F2DC835E20;
        Thu, 13 Jan 2022 08:10:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06B8E5E48A;
        Thu, 13 Jan 2022 08:10:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <b274b05b-db23-2b11-c347-fbfe3de0917d@linux.alibaba.com>
References: <b274b05b-db23-2b11-c347-fbfe3de0917d@linux.alibaba.com> <20211228124419.103020-1-jefflexu@linux.alibaba.com> <693ab77bab10b38b1ddab373211c24722e79fee2.camel@kernel.org>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [PATCH] netfs: make ops->init_rreq() optional
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1481798.1642061433.1@warthog.procyon.org.uk>
Date:   Thu, 13 Jan 2022 08:10:33 +0000
Message-ID: <1481799.1642061433@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Yep.  My patchset got pulled, so I'll take it now.

David

