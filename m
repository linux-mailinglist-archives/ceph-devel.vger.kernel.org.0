Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A85300842
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Jan 2021 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbhAVQIv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Jan 2021 11:08:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729255AbhAVQIb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 11:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611331622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LxEIC8hGatT2o24RK/5B1chyfP2tF4vZvBCyA+dON/4=;
        b=bqa/f1NhGpoismsKAjxk9qoAeTNy8dK0AHUA/bfs3XJMdSdga5IKS2NyZoksOj1bLX1m2O
        LgmVeSiZjsdtAdUNYN0hxCMr5AVEoTsCceLVoLEKAvdJAZj5E2maMQ+XE5ziU3z2NoAk+2
        CeZBWBI/0kf/7uvluYPmdCgIEL8r86M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-WxgM7MKlOBu2zSsKQiqVFw-1; Fri, 22 Jan 2021 11:06:58 -0500
X-MC-Unique: WxgM7MKlOBu2zSsKQiqVFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78A118144E0;
        Fri, 22 Jan 2021 16:06:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A07F418993;
        Fri, 22 Jan 2021 16:06:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210122160129.GB18583@fieldses.org>
References: <20210122160129.GB18583@fieldses.org> <20210121190937.GE20964@fieldses.org> <20210121174306.GB20964@fieldses.org> <20210121164645.GA20964@fieldses.org> <161118128472.1232039.11746799833066425131.stgit@warthog.procyon.org.uk> <1794286.1611248577@warthog.procyon.org.uk> <1851804.1611255313@warthog.procyon.org.uk> <1856291.1611259704@warthog.procyon.org.uk>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     dhowells@redhat.com, Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Takashi Iwai <tiwai@suse.de>,
        Matthew Wilcox <willy@infradead.org>,
        linux-afs@lists.infradead.org, Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-cachefs@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/25] Network fs helper library & fscache kiocb API
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2085146.1611331606.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 22 Jan 2021 16:06:46 +0000
Message-ID: <2085147.1611331606@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > J. Bruce Fields <bfields@fieldses.org> wrote:
> > > So, I'm still confused: there must be some case where we know fscach=
e
> > > actually works reliably and doesn't corrupt your data, right?
> > =

> > Using ext2/3, for example.  I don't know under what circumstances xfs,=
 ext4
> > and btrfs might insert/remove blocks of zeros, but I'm told it can hap=
pen.
> =

> Do ext2/3 work well for fscache in other ways?

Ext3 shouldn't be a problem.  That's what I used when developing it.  I'm =
not
sure if ext2 supports xattrs, though.

David

