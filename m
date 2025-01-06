Return-Path: <ceph-devel+bounces-2400-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5224A01EB1
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2025 05:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5254D1882015
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2025 04:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5F71487C8;
	Mon,  6 Jan 2025 04:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="LHbI10dq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523C7AD24
	for <ceph-devel@vger.kernel.org>; Mon,  6 Jan 2025 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736139449; cv=none; b=osQBECo5DAxGEgNN2Dxbk48I8RTz+no6wX4RNjEYJGSj2fLpd4SZo8qxtK7srS8UfKz3Qqcfvck26145UBEvyeFlf41wRCaIZljxZ40x5QQMNaqJME/0he4sDXMvcDxbi2CbxLHj1xTev4Vr15ua8T0gzONqclezTpp2WPJorHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736139449; c=relaxed/simple;
	bh=AzzMwFQqa+QRnReQHo4C0U5S4KaZHJCC7cHx35WRbxY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FcArmkLJig0J501xTJGY3GLPZXMKw5ssYGTsOEA09aVQ/4bLjhf29Mqg/Bp86zhS3/p5+ACeHxN4+5KQovmSv5QstgAM08zv/t1HpbsOzXYqv3eO31X8zWkY5hVDvzsZMqn++1Qi72bkhEXPYGW3Sb8DG4uxO969Ud0Emfy4HFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=LHbI10dq; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ISK9clZRbgB9+YALimXXH7PYAp8qh5IdrrY2qahkwLo=; b=LHbI10dqYPi/czFAgtbMdt8qAn
	8TWNV9cJBpZwPpUlN29XB+8yYmVxrFvCBDGDFqe5aU/YOS0L2bDfnjvcY2CqZJkaVgQH95sxzcHMy
	S+fOBR0j+WtiQF+N0NxL0XbJuoqsYWlDjgog2IHf9spCoEjjydXwsPmYD73TQrmL/XiFbnrh09H8C
	WJ2isNAmbSs37t3Jw8K/gqEJ8gnYR7x92UyGbFy0VpfhayQmD2n4ZOjNwygNF/Aq2EAHSJwVN93Ec
	uYPH3JJH2Gcbxp0ATWcNw+56h2wAEqiCIcbq1xXJ+teVbG3MiVpN/GUyh2+LwAR26glFDTTQJrgo9
	8p/30vhg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUfB6-0000000FuJp-0LmM;
	Mon, 06 Jan 2025 04:57:24 +0000
Date: Mon, 6 Jan 2025 04:57:24 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Milind Changire <mchangir@redhat.com>, ceph-devel@vger.kernel.org
Subject: [RFC] odd games with d_find_alias() in ceph_unlink()
Message-ID: <20250106045724.GM1977892@ZenIV>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	In 2827badaf8162 "ceph: check the cephx mds auth access for async dirop"
you've added the following chunk:

+       dn = d_find_alias(dir);
+       if (!dn) {
+               try_async = false;
+       } else {
+               path = ceph_mdsc_build_path(mdsc, dn, &pathlen, &pathbase, 0);
+               if (IS_ERR(path)) {
+                       try_async = false;
+                       err = 0;
+               } else {
+                       err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
+               }
+               ceph_mdsc_free_path(path, pathlen);
+               dput(dn);
+
+               /* For none EACCES cases will let the MDS do the mds auth check */
+               if (err == -EACCES) {
+                       return err;
+               } else if (err < 0) {
+                       try_async = false;
+                       err = 0;
+               }
+       }

What was that d_find_alias() for?  I mean, we are in ->unlink(); we'd
bloody well better have dentry->d_parent->d_inode == dir and dir locked
exclusive.  If that is _not_ true, we have a really big pile of problems
all over the place...  So your d_find_alias() is an obfuscated
	dn = dget(dentry->d_parent);
and even dget() is pointless here - dentry->d_parent is pinned, will stay
so and won't change.

What's wrong with simply

+       path = ceph_mdsc_build_path(mdsc, dentry->d_parent, &pathlen, &pathbase, 0);
+       if (IS_ERR(path)) {
+               try_async = false;
+               err = 0;
+       } else {
+               err = ceph_mds_check_access(mdsc, path, MAY_WRITE);
+       }
+       ceph_mdsc_free_path(path, pathlen);
+
+       /* For none EACCES cases will let the MDS do the mds auth check */
+       if (err == -EACCES) {
+               return err;
+       } else if (err < 0) {
+               try_async = false;
+               err = 0;
+       }

instead?  What am I missing here?  The same goes for the part in ceph_atomic_open()...

