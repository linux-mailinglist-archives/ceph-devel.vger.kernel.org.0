Return-Path: <ceph-devel+bounces-2962-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D26F9A67FC7
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 23:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6202019C518A
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 22:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315EF207A16;
	Tue, 18 Mar 2025 22:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KP4FsNBi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77554F9DA
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 22:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336756; cv=none; b=s9SdY9ZG/yoTdDVnRglM65l/K6opyvrmcpBl9qrRr7NEuohS8VE0Ear6dBoQ2kmSggjdWgavk8LHNsPFRpOKGrOEgRJCTT5NAHg8oY8m0+e3c6gbzQJJc4PYG1Psf9lRAxMJXArs5f0YKZrPmXmVems8WJHUQs11sY15Z5CzZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336756; c=relaxed/simple;
	bh=WYttGZXmD4cKFkUXnUNkffMsh2E75ADt+rGXc7/+aAg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=GHf07LWgcLdYd+srdN6c7T6SAMs9CpqQg16te39NEWkXjbnZo0vNPSTWKLDcTsYgfSGpzhhPZAWWbyzDBAAtu4ZwcVHDD2t971WO//7YAnPJql2uSzPKqAW05V9PG+5nd8T4No/ZqCStgXHouGKVUu6QqANoP5J+EH6UGWWEUkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KP4FsNBi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742336753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXP1KeTdnfZjUbQUXpsqMI81bUzhxqR/ZEJh3ypYI5Q=;
	b=KP4FsNBi+Bum9jZeWrhEBcDrOG+DHyV3DOIABI0f325CNKsZAe7a2tbW+ykcvaBrqYoNS3
	fYjqsB7oXnVjx4D/4GCefyJy4FlnqFn0Fp4f5mn2JcedUTXRQWBCn0MiyW/OCHHtsi/b74
	y3c0RLWi3S2cDMRSxuQ6p8ECvYK/leQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-MCodP1_pPhu8Y-IsTOg3Cw-1; Tue,
 18 Mar 2025 18:25:47 -0400
X-MC-Unique: MCodP1_pPhu8Y-IsTOg3Cw-1
X-Mimecast-MFC-AGG-ID: MCodP1_pPhu8Y-IsTOg3Cw_1742336744
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FDCA19560B8;
	Tue, 18 Mar 2025 22:25:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7BAE19560AD;
	Tue, 18 Mar 2025 22:25:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4413c4ed03696b76ccd7903a87bd4c72ad9c883e.camel@ibm.com>
References: <4413c4ed03696b76ccd7903a87bd4c72ad9c883e.camel@ibm.com> <20250313233341.1675324-1-dhowells@redhat.com> <20250313233341.1675324-19-dhowells@redhat.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    "slava@dubeyko.com" <slava@dubeyko.com>,
    "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
    "idryomov@gmail.com" <idryomov@gmail.com>,
    "jlayton@kernel.org" <jlayton@kernel.org>,
    "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
    "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
    "dongsheng.yang@easystack.cn" <dongsheng.yang@easystack.cn>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 18/35] libceph, rbd: Convert some page arrays to ceph_databuf
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2680899.1742336740.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Mar 2025 22:25:40 +0000
Message-ID: <2680900.1742336740@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> >  	/*
> >  	 * The response data for a STAT call consists of:
> > @@ -2118,14 +2118,12 @@ static int rbd_osd_setup_stat(struct ceph_osd_=
request *osd_req, int which)
> >  	 *         le32 tv_nsec;
> >  	 *     } mtime;
> >  	 */
> > -	pages =3D ceph_alloc_page_vector(1, GFP_NOIO);
> > -	if (IS_ERR(pages))
> > -		return PTR_ERR(pages);
> > +	dbuf =3D ceph_databuf_reply_alloc(1, 8 + sizeof(struct ceph_timespec=
), GFP_NOIO);
> =

> What this 8 + sizeof(struct ceph_timespec) means? Why do we use 8 here? =
:)

See the comment that's partially obscured by the patch hunk line:

	/*
	 * The response data for a STAT call consists of:
	 *     le64 length;
	 *     struct {
	 *         le32 tv_sec;
	 *         le32 tv_nsec;
	 *     } mtime;
	 */

If you want to clean up and formalise all of these sorts of things, you mi=
ght
need to invest in an rpcgen-like tool.  I've occasionally toyed with the i=
dea
for afs in the kernel (I've hand-written all the marshalling/unmarshalling
code in fs/afs/fsclient.c, fs/afs/yfsclient.c and fs/afs/vlclient.c, but t=
here
are some not-so-simple RPC calls to handle - FetchData and StoreData for
example).

David


