Return-Path: <ceph-devel+bounces-1550-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C4993ACA1
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 08:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12589B20F0A
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 06:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7675F5025E;
	Wed, 24 Jul 2024 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKAWc314"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A52B4C84
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721802578; cv=none; b=TfFW/gG+gLwT1hbJeevuHzQL3tMgZGVCF8HvpuHmnzF/9kYeMpVB+JyRFvzKkuBvjkHz9wVjWrC0Y9wmW1OqhqH9EH4x60DNUz9qewhtMMCI911h6EUnQK8aGXvpLXBfBqaqMiG4maLy37mDHOWaqDUXS9vR6KAojf+lQWmAUjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721802578; c=relaxed/simple;
	bh=SFCQn3+p9JAgD0wXH0/qhfnRZBTEeI7Xfa+C5JuBRKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sob66Go7oLBfiL7uK4N00+2BnkYaHJTY3MPYqF68gmhgzl7ccsKKXsq5pWWB+ZRiwjcsubyUA7Gr4TXVO/egJABeRqMqNr+LgFSYE/ETOoOS1JT/KFddO8PjTjRD2WuaL7+0BtxREbAinbI3d+dnjW0Jv3/I1/0Vunm4Cy5Cf4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKAWc314; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4279c924ca7so46570225e9.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 23:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721802575; x=1722407375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ERASEnuWrfvAtUQyflJYkYlh7dLSYaPlXJiMbJlLM4k=;
        b=UKAWc314zT7EAFKkqlT3H1JfRJvUxyUHsp2PxFkqiqccSXuTQwxkGJdccjO4vOCT7V
         WY2lnO+mMrFjUhiXr7kekcWqC5Fdek3rJbWDSYFIYdESxXhto5J/0f/NxCRDRVsZzd+o
         XVmEHo3zMem74kT+ovlYMKJkLjTE9q7sqUUfcw4hJOTWXfoH/EyAhL22qduxcvRmIIp+
         kD/l9CGx/a7XUqPiJOHziBDdxl2Fhf1dV1ElTbjfUT68Thh62S2tGwut+8r1lhmAFd+R
         VIKtVfwYD8hyqkqL2KrVbKYrzM3QH4mv+F82copZJiSFn5V3BzN0on2sBCZ+6LavfIXO
         sfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721802575; x=1722407375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERASEnuWrfvAtUQyflJYkYlh7dLSYaPlXJiMbJlLM4k=;
        b=NzOueyEEws6ITp/9HE2Y1kHdeO2276gDv49F6QFdOEZdtjIZv4GKdBnr42Zx84rwaM
         24Y2WUcmhSqnmP4Zk36/2Q2cEOgXtxqVfP13agi35y0tPvCfwhYZPwrh9A4PdPvANfoO
         EyvrVoLDwcQqKhNYQG22Y52swoSjskwWxqPHBHmNxWJYamwW7zoH0VOmm1vIO+IN9hQm
         2bwXxPevdX8zTIusuKzkrjkEwSAx1sqhiz0vk5+iy43oN/FK3guAWa3L4gsr6CjVN7Vt
         rmHrt4zPZsRuOzZZkW9HGs065Ni/A4d2q2yYg45Ywmqkvalpo+0VQj1RQXUxBLq+Frj4
         J0lw==
X-Gm-Message-State: AOJu0YwdLb7pE+eABLFdUPysiS1DrN59UczIcBV5e5SPdRQSJyZcU5BQ
	6yRUG5hHoYLVPOzCbvq5M/IQj9C6KgaxyV3gW9+/fjf0QH6mkQ4iJhyXwg==
X-Google-Smtp-Source: AGHT+IHw9jfRSfLvwo6dRiBPY7CfbvBYo6Oktlqu5aJZXdIKn6sBAHz8ldaHgZX+/w84RcL/w9gY7Q==
X-Received: by 2002:a05:600c:1f8d:b0:426:6158:962d with SMTP id 5b1f17b1804b1-427f7a645c9mr12219735e9.23.1721802574744;
        Tue, 23 Jul 2024 23:29:34 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f9359516sm14160325e9.2.2024.07.23.23.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 23:29:34 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 0/3] rbd: exclusive mapping (-o exclusive) fixes
Date: Wed, 24 Jul 2024 08:29:08 +0200
Message-ID: <20240724062914.667734-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This addresses incorrect assumptions on rbd_dev->lock_state in
rbd_img_exclusive_lock() and rbd_add_acquire_lock() which could lead to
issues with exclusive mappings in the face of watch errors.

Thanks,

                Ilya


Ilya Dryomov (3):
  rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait
  rbd: don't assume RBD_LOCK_STATE_LOCKED for exclusive mappings
  rbd: don't assume rbd_is_lock_owner() for exclusive mappings

 drivers/block/rbd.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

-- 
2.45.1


