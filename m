Return-Path: <ceph-devel+bounces-2971-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE53A6875D
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 10:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96E9F3AB5B7
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 09:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89501E1DF8;
	Wed, 19 Mar 2025 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWTCciXT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4162AEE2
	for <ceph-devel@vger.kernel.org>; Wed, 19 Mar 2025 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742374945; cv=none; b=bfftVH0sT4e10QtgsidxbPubAxH6GcslwrXDAe/T8e7gnl3QwJm6QMisk5gnqC2Wt8KkF64Zxj5zNDeI6hzP7n8OZK3ES/OryQmV4KxltJuITkPw4QTIB+JTUwgRadCQyjkWu9HADgVBQH6GPEViMT+xIEVI+sBfMOWtNTuoYEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742374945; c=relaxed/simple;
	bh=pYdPZNVg++xcrSxh9CTS5jiySW/9UeLsjnl7OKLNil4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=gcl0teDyKHGMEk+zoGPbiJow/R0FpE61daIBhMZyVKi+IMDXaiJVAS/hqk1WzchG8DUHZDazwQPe/D4Q8LejIcCkwWcosjhpIqeJ9ALbEG08aixg9leqGX80bThUORBO7WDG8UZLeTqLjBbpZ2fWpLivubMx3TbltAp4J9/op8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OWTCciXT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742374942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MvDJKlmTteIriOl2fJphKJ0Zp8IPWb8d6n12Oj4dVZg=;
	b=OWTCciXTtJbbEAf/i/sNzzsUS2uicQ/siZdZZpJf4Rky712k5sBbPPlkczR66CNoJPi3kl
	LkQWgGkuVLzMtCp0O2PPK3a5eeDKmz7Yf6RWhz02dTBFSmb27HKFDU4+gYUR21BbU1CDPi
	tSNsmPsoqjsnLyq8luNa30B9y9B/jAs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-324-9sRavCU0P8Si6PS7wXPXog-1; Wed,
 19 Mar 2025 05:02:18 -0400
X-MC-Unique: 9sRavCU0P8Si6PS7wXPXog-1
X-Mimecast-MFC-AGG-ID: 9sRavCU0P8Si6PS7wXPXog_1742374937
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 901C619560AF;
	Wed, 19 Mar 2025 09:02:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BEDC1956094;
	Wed, 19 Mar 2025 09:02:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Z9oA3xSwEQgWzZ83@debian>
References: <Z9oA3xSwEQgWzZ83@debian> <Z9nFlkVcXIII8Zdi@debian> <Z9m7wY8dGAlq4z0K@debian> <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com> <2681465.1742337725@warthog.procyon.org.uk>
To: Fan Ni <nifan.cxl@gmail.com>
Cc: dhowells@redhat.com, slava@dubeyko.com, ceph-devel@vger.kernel.org,
    Slava.Dubeyko@ibm.com
Subject: Re: Question about code in fs/ceph/addr.c
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2700938.1742374935.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Mar 2025 09:02:15 +0000
Message-ID: <2700939.1742374935@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Fan Ni <nifan.cxl@gmail.com> wrote:

> That is very useful information to me, since I am still slowly ramp-up m=
m work and lack
> of the whole picture of mm development work. =

> =

> Just to make it more clear to me, so that means all &folio->page and lik=
e
> will be taken care of with your patches for fs/, right? If so, I will sk=
ip fs
> and try to work on other sub-system.

Yes-ish.  What you're trying to do might already have been taken care of b=
y
Willy for the next merge window:

	https://web.git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=3D=
vfs-6.15.ceph

I based my branch on this.

David


