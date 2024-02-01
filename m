Return-Path: <ceph-devel+bounces-790-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FA4845654
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Feb 2024 12:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C6BD287120
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Feb 2024 11:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA87015B99C;
	Thu,  1 Feb 2024 11:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DODRbEAD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A232134A
	for <ceph-devel@vger.kernel.org>; Thu,  1 Feb 2024 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706787448; cv=none; b=oho7b8hzWkKdiyM6z1D2aJOCDjfUQNr5P6aU6G1Jwfn5BQ/4RECfAsHMgzhlLPUsCez3wzl7wOnALLt2591iC/5Yo2eqxJjaNrGfA2gGGmrnNJB6C5SpKblTGRGcQ0WJJ8BE9qozNzVExOOfPW42GkCCADaXXwFawHxm1bhz2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706787448; c=relaxed/simple;
	bh=j19lu6DLLl1CEoEgKzN1WnoAGBEBmDIKbp+ZeGi6hTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VMgAswfBlCY6cSO3eXRefnTHlGF7ke1eJpvc4UAdxF/yWAEua7+xV5wuekTQPyMZQ3bJFoFBmV/eaFXcdr9ZZImzNLDrbGun0Kjuf/AC4xxgbJDM+sTmc1qwkacP2LhqkaOwZj5TChgtAZgZPyfGEUWy39sdtVJl0MtCf1WlPSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DODRbEAD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706787445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xMC118SZ0aLL0/ts+pyCr6/BBwnNdxRg4waSjQ7TOlg=;
	b=DODRbEADmSazi4ju5P6h83HXlE4uJ/Vth4L8lu11V/L7+swSwP+SAksFghn+mernuZWC9/
	s5VlgWiJhX2aopHWszcr6LZw18pRGBor4SIlaX6pFBUMgDjZmc8VjLYC89Px5dkxDhjzuk
	jRMDzJJefVmCU0TFhRQ5voqVgj9qr9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-E3rmL95wN8OYn9KwBTJ99A-1; Thu, 01 Feb 2024 06:37:22 -0500
X-MC-Unique: E3rmL95wN8OYn9KwBTJ99A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5A9C185A784;
	Thu,  1 Feb 2024 11:37:21 +0000 (UTC)
Received: from p1g5.redhat.com (unknown [10.74.17.5])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 40D7A1BDB0;
	Thu,  1 Feb 2024 11:37:18 +0000 (UTC)
From: ridave@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	idryomov@gmail.com,
	vshankar@redhat.com,
	mchangir@redhat.com,
	xiubli@redhat.com,
	rishabhddave@gmail.com,
	Rishabh Dave <ridave@redhat.com>
Subject: [PATCH] ceph: increment refcount before usage
Date: Thu,  1 Feb 2024 17:07:16 +0530
Message-ID: <20240201113716.27131-1-ridave@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Rishabh Dave <ridave@redhat.com>

In fs/ceph/caps.c, in "encode_cap_msg()", "use after free" error was
caught by KASAN at this line - 'ceph_buffer_get(arg->xattr_buf);'. This
implies before the refcount could be increment here, it was freed.

In same file, in "handle_cap_grant()" refcount is decremented by this
line - "ceph_buffer_put(ci->i_xattrs.blob);". It appears that a race
occurred and resource was freed by the latter line before the former
line
could increment it.

encode_cap_msg() is called by __send_cap() and __send_cap() is called by
ceph_check_caps() after calling __prep_cap(). __prep_cap() is where
"arg->xattr_buf" is assigned to "ci->i_xattrs.blob" . This is the spot
where the refcount must be increased to prevent "use after free" error.

URL: https://tracker.ceph.com/issues/59259
Signed-off-by: Rishabh Dave <ridave@redhat.com>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5501c86b337d..0ca7dce48172 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1452,7 +1452,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	if (flushing & CEPH_CAP_XATTR_EXCL) {
 		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
 		arg->xattr_version = ci->i_xattrs.version;
-		arg->xattr_buf = ci->i_xattrs.blob;
+		arg->xattr_buf = ceph_buffer_get(ci->i_xattrs.blob);
 	} else {
 		arg->xattr_buf = NULL;
 		arg->old_xattr_buf = NULL;
@@ -1553,6 +1553,7 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 	encode_cap_msg(msg, arg);
 	ceph_con_send(&arg->session->s_con, msg);
 	ceph_buffer_put(arg->old_xattr_buf);
+	ceph_buffer_put(arg->xattr_buf);
 	if (arg->wake)
 		wake_up_all(&ci->i_cap_wq);
 }
-- 
2.43.0


