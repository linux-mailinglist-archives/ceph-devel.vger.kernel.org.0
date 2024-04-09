Return-Path: <ceph-devel+bounces-1067-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7373C89D786
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Apr 2024 13:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E36028839E
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Apr 2024 11:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C84584FCE;
	Tue,  9 Apr 2024 11:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZv5PDlH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FA481751
	for <ceph-devel@vger.kernel.org>; Tue,  9 Apr 2024 11:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712660519; cv=none; b=oQf1TgODhvrVXEkuL9UOnFYbGMjwISlDyH4cVoygf3GW0mjxO4819tsr2/OyOaW1ogartZXBBun9ccrZ/7C0mvyvwgCRxXeIkPwpKA/Nkzl/JT5BGEteK+Aw1+ucNrOT2aKLgp4AkKuJdvfzNp1PEmMLTqkS6Eq/MvBcFcU6FXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712660519; c=relaxed/simple;
	bh=a0ae3wMsYTycHjMXrn/FDlCtXRMEtYTi2bTP+CF7XuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J9lMUcHxBrGG+kE1Rpr18y6HO/VaQ8SMNM+OBYSJnOpvLkwCJORmuL0LuHB+wJ6gds3UvBHiXaboxMUYURJEvcVaYoTJgdTnqPYbmEld7cChAGpz6S83W//OBwhK/U077m2fomECvE8iNUy4YecORw08+AH6j4UO5jxC3OZjUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZv5PDlH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCA7C433F1;
	Tue,  9 Apr 2024 11:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712660518;
	bh=a0ae3wMsYTycHjMXrn/FDlCtXRMEtYTi2bTP+CF7XuQ=;
	h=From:To:Cc:Subject:Date:From;
	b=bZv5PDlHLQBoLBUUiWm6OKUwVdEoSioUDAQyt7T+20mBHoEK7R2Z8Z7jydBSH4u20
	 TQqIQzYaAn2wyMrtEx0FgSSZrt02KgEDd0zAY1JYSXvl0PLFwGqg5IRNXg0MSYJFUc
	 nCqOlrKO8VkYFEU/DCNV+0mEwfSix9UHs891Pw5SIM5wb3eQ+dwc8Os7kaM8Fs6Hid
	 vnwzRFE0CdEfdb74EGHapI++LWT7qgm4OWaa2c5EeY/5YcxTk30PvB0cL0sDTkwd9O
	 mDr+TWDe2Q/o3pUutHrfN1kqJtaUZdrAVrI0MPrC5gAH8GmwtFHDmAao7Li41EvpcZ
	 HoC7RZeZAEsdA==
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com,
	idryomov@redhat.com
Cc: ceph-devel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove myself as a Reviewer for Ceph
Date: Tue,  9 Apr 2024 07:01:57 -0400
Message-ID: <20240409110157.20423-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It has been a couple of years since I stepped down as CephFS maintainer.
I'm not involved in any meaningful way with the project these days, so
while I'm happy to help review the occasional patch, I don't need to be
cc'ed on all of them.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aea47e04c3a5..c45e2c3f6ff9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4869,7 +4869,6 @@ F:	drivers/power/supply/cw2015_battery.c
 CEPH COMMON CODE (LIBCEPH)
 M:	Ilya Dryomov <idryomov@gmail.com>
 M:	Xiubo Li <xiubli@redhat.com>
-R:	Jeff Layton <jlayton@kernel.org>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
@@ -4881,7 +4880,6 @@ F:	net/ceph/
 CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
 M:	Xiubo Li <xiubli@redhat.com>
 M:	Ilya Dryomov <idryomov@gmail.com>
-R:	Jeff Layton <jlayton@kernel.org>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
-- 
2.44.0


