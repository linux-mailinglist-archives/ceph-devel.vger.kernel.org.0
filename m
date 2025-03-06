Return-Path: <ceph-devel+bounces-2873-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC996A54FBE
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 16:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E49CC3A40D1
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 15:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C171FF7CC;
	Thu,  6 Mar 2025 15:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBFYLZ7d"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5132101A1
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276554; cv=none; b=b/72Ic3Qk2asOJw5WRMVTqDKGrwFCI8f4LYxK9FnMcUeat0BqDL+4zxEylEuaDTCZRpmxsp1uY2pi+puULp24jKAF/Xwy2Bc6VEVJ1mSLRZTqe3ZDi0hWAQfNPmJJ11KgeAI/lKikp/Ty0ZAGocTYkBE+Qfuh6IgvbaZpxSlr7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276554; c=relaxed/simple;
	bh=kObqhbINUHnq58Ts0ynAFMe+oPoTJu0RezAjeLWYy8g=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ZedvD7BI309qm+ZKEs1i4gU8x0M4oFo54yu/zR4ehMEoeAd4RCiwTYrRx2uMeU9Vjcmne23RWzkiR8BqFRMNpHlPAab5JtLDsPv2aP5ycY57/ebaV/TT6ulQp/ZTBqvoOg81gruT+vYgz8RGkHtYZh+VEshHZBvCRFenabiT6dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hBFYLZ7d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741276551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8NHhi27aZByFhZvPPNchTEignqTE3P+TbomjiQklZyg=;
	b=hBFYLZ7dBHFvbbwOstdg5ionYYFtxGtzofLpnZarygiCXy2Oy4OLi0WTI2lSZKNtAC5rbB
	CkYHBDTk9UXor58XBcYCHU7er3U1ihOkomIcVB4/DtN77CJFt3/yJPXyAess5JKVqxPOSZ
	f9tkPfsafZEdir1QF1tnn6Fqm/EupD4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-VLCruU2AOeutzI0ShvquKw-1; Thu,
 06 Mar 2025 10:55:43 -0500
X-MC-Unique: VLCruU2AOeutzI0ShvquKw-1
X-Mimecast-MFC-AGG-ID: VLCruU2AOeutzI0ShvquKw_1741276542
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 737BF1956083;
	Thu,  6 Mar 2025 15:55:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 563571955DCE;
	Thu,  6 Mar 2025 15:55:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
References: <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com> <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
To: Alex Markuze <amarkuze@redhat.com>
Cc: dhowells@redhat.com, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
    Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
    Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    Gregory Farnum <gfarnum@redhat.com>,
    Venky Shankar <vshankar@redhat.com>,
    Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: Ceph and Netfslib
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <132457.1741276536.1@warthog.procyon.org.uk>
Date: Thu, 06 Mar 2025 15:55:36 +0000
Message-ID: <132458.1741276536@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Does ceph_write_iter() actually need to drop the inode I/O lock in order to
handle EOLDSNAPC?  I'm wondering if I can deal with it in the netfs request
retry code - but that means dealing with it whilst the I/O lock is held.

David


