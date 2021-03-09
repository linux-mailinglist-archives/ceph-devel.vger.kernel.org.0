Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1E333140
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Mar 2021 22:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhCIVsu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Mar 2021 16:48:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231915AbhCIVsb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Mar 2021 16:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615326510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iwbii2y0aUd6JdTMAjESiwVonfx2aADnJiKOzTNCZ3E=;
        b=CKWU/c8fXGBm79qzZPBIFWl1QTCwGlmfPw1ax82TyBWjUq2ewBY3f5IuSB71MJw/kTdjcn
        rXROrZxpCU2KkUWVG76aXn4U5QN/D7Kt1yhPBE5BNRrCIl19g5KqBBVJniSUkbnYFFoZhc
        TZ8ElBBGpA2wjCpi09EasnmTCdWylsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-C00nYY20OyuwgTz0MAYt6w-1; Tue, 09 Mar 2021 16:48:28 -0500
X-MC-Unique: C00nYY20OyuwgTz0MAYt6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 782BF2F7A2;
        Tue,  9 Mar 2021 21:48:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-152.rdu2.redhat.com [10.10.118.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6A6D19C46;
        Tue,  9 Mar 2021 21:48:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAOi1vP9g+wFpw6ws5ap9T4nbPxLK0J-KegeoH4HZXQhC=UL2-g@mail.gmail.com>
References: <CAOi1vP9g+wFpw6ws5ap9T4nbPxLK0J-KegeoH4HZXQhC=UL2-g@mail.gmail.com> <ac3703b3b382cc6e947904238e3dc4c671eb7847.camel@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     dhowells@redhat.com, Ceph Development <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: ceph-client/testing branch rebased
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <201975.1615326505.1@warthog.procyon.org.uk>
Date:   Tue, 09 Mar 2021 21:48:25 +0000
Message-ID: <201976.1615326505@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> wrote:

> Could you please create a named branch that doesn't include AFS bits
> (e.g. netfs-next)?  It is going to be needed once we get closer to
> a merge window and netfs helper library is finalized.  I won't be able
> to pull a seemingly random SHA (of the commit preceding the first AFS
> commit) into ceph-client/master.

I will do.  Currently I'm slightly stalled waiting on Willy.  He wants me to
make some changes and I'm hoping he'll tell me what they should be at some
point.

David

