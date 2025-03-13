Return-Path: <ceph-devel+bounces-2886-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B8837A5F06E
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 11:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07B5F17CED4
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 10:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04C3265618;
	Thu, 13 Mar 2025 10:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D08O7btk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA092265603
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 10:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741861076; cv=none; b=ld/UzDWgf3Yku/Z8u4jb6bYmriwIQFQYlZoMq10i173HlHS+yU5rrCjrsaqSLIRS5dqwt5N4AWtHShdaz/Ullr+//N8Ag2GX/Q6OCNGV1TykOevtjXhZxaByX/fTb8hI/Z8bFZT8FK2F6zBg341N4sXCAXYiiAKjLt8rAQbZN5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741861076; c=relaxed/simple;
	bh=/Shtpfb7BHCmzgzI2E8QdrJ71iVjmgVHThFuwFqzFtg=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=JSQoGzAWhtUxJKK8fZypBchPmWCmj4eNoKUYFkjF/sBV4qrR/MZBgKJyNeEC+ZM4AYn435EzbUEeQfJSZDVYy1YbjZ1rTSeLaAZZPv1RtZVcB0/dwXEp+H2OgiJO+OpqId1zChnCc0n9oNuuqkHHi7LP8/z3QLXcvXDgPKIHkaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D08O7btk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741861073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9PuNOtOdGXpJpaKSTTpElFraHIPQkY93SwNR6N9vnoY=;
	b=D08O7btkmIbVxm2ihcEgdR/v41ic8sB7EYAutQ3qBBncR+2a1zSMd8w7secNSNPMyLCnUn
	S94ie9DHsUHtAQ9tPe/21+SR0h8kk2LPjzSYH2SXNlmOii8MOZ1XKwjjgFu2IZZ5bCm3QT
	ILIIBpgmczRTm4M3vrzZaAa2hSr9D4Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-x84u6bDdNuuDAdK_8PXEiw-1; Thu,
 13 Mar 2025 06:17:49 -0400
X-MC-Unique: x84u6bDdNuuDAdK_8PXEiw-1
X-Mimecast-MFC-AGG-ID: x84u6bDdNuuDAdK_8PXEiw_1741861068
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30EB9195608B;
	Thu, 13 Mar 2025 10:17:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A73AE1800945;
	Thu, 13 Mar 2025 10:17:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
cc: dhowells@redhat.com, Alex Markuze <amarkuze@redhat.com>,
    Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
    Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Does ceph_fill_inode() mishandle I_NEW?
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1385371.1741861062.1@warthog.procyon.org.uk>
Date: Thu, 13 Mar 2025 10:17:42 +0000
Message-ID: <1385372.1741861062@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

ceph_fill_inode() seems to be mishandling I_NEW.  It only check I_NEW when
setting i_mode.  It then goes on to clobber a bunch of things in the inode
struct and ceph_inode_info struct (granted in some cases it's overwriting with
the same thing), irrespective of whether the inode is already set up
(i.e. if I_NEW isn't set).

It looks like I_NEW has been interpreted as to indicating that the inode is
being created as a filesystem object (e.g. by mkdir) whereas it's actually
merely about allocation and initialisation of struct inode in memory.

David


