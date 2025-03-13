Return-Path: <ceph-devel+bounces-2889-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B06A602F6
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 21:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40D643BA5CE
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 20:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D0A1F4727;
	Thu, 13 Mar 2025 20:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="irREP7Hb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B716B3A1
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 20:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898879; cv=none; b=atHI5Qh+VgyxI10pQUjiVh2J5jkDvnyx6Cd0hbr/aeDqNNwank8nCZ9yF5itVMqbOb16BHVWzEFzkQX5DBLturj+BBqsFPka2JlWkESuGX0MMvfuWaue3k0WlG39Ok/1AtwHGAsoGGjhzEInlzIibPjTPBKKyGBJYjqoN0B22Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898879; c=relaxed/simple;
	bh=BJAL/2BqmnF2wqJ0CNyA2TidlwFu13d/cuLzBvREwgM=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=UctRieNndSkPTUX1JPsUMQy7kadx+hAnOoJF6YZxRtX0tDsFn6yZp45z/n2SQ3wNbX5Wl42CB7tNhpiuWgMTJuj0GHlJQsI/JCfPlkLqr+kGjATk8l2XsJ9GplHch4QA5nAcw286ieNm8CowlbVsmMBzW9fwvGa2mz6o2dBfH4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=irREP7Hb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741898877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6524Cf8HlDwGjtyKBEw77UKWV6Y0ZpYj68qA0nrJekk=;
	b=irREP7HbtZ2JVQu5PCI4HDGH6rP7dqyHXkCIVWeJYuhvn8Jt81fowaR0eBnI3uba2oGLR2
	UxTcNSaknFz3xEx9ExnaL304Oclk5M9C4PHSEnzyer/yXZALp2TDHeBIw1Tv6iN7z7jZrS
	fVAz3UFN6de0v5/C6UMz9aFIGy9Z7cg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-XrGS2Ke0P9Ki2Sy3jOvxVg-1; Thu,
 13 Mar 2025 16:47:52 -0400
X-MC-Unique: XrGS2Ke0P9Ki2Sy3jOvxVg-1
X-Mimecast-MFC-AGG-ID: XrGS2Ke0P9Ki2Sy3jOvxVg_1741898871
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C6271955E80;
	Thu, 13 Mar 2025 20:47:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29AF21955BCB;
	Thu, 13 Mar 2025 20:47:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3cc1ac78a01be069f79dcf82e2f3e9bfe28d9a4b.camel@dubeyko.com>
References: <3cc1ac78a01be069f79dcf82e2f3e9bfe28d9a4b.camel@dubeyko.com> <1385372.1741861062@warthog.procyon.org.uk>
To: slava@dubeyko.com
Cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
    Jeff Layton <jlayton@kernel.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>,
    Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    Slava.Dubeyko@ibm.com
Subject: Re: Does ceph_fill_inode() mishandle I_NEW?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1468675.1741898867.1@warthog.procyon.org.uk>
Date: Thu, 13 Mar 2025 20:47:47 +0000
Message-ID: <1468676.1741898867@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

slava@dubeyko.com wrote:

> What do you mean by mishandling? Do you imply that Ceph has to set up
> the I_NEW somehow? Is it not VFS responsibility?

No - I mean that if I_NEW *isn't* set when the function is called,
ceph_fill_inode() will go and partially reinitialise the inode.  Now, having
reviewed the code in more depth and talked to Jeff Layton about it, I think
that the non-I_NEW pass will only change pointers with some sort of locking
and will release the old target - though it may overwrite some pointers with
the same value without protection (i_fops for example).

That said, if it's possible for *two* processes to be going through that
function without I_NEW set, you can get places where both of them will try
freeing the old data and replacing it with new without any locking - but I
don't know if that can happen.

David


