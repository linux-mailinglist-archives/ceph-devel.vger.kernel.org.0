Return-Path: <ceph-devel+bounces-1629-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 168109461FF
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 18:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CC42811B7
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 16:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5CD136322;
	Fri,  2 Aug 2024 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWAD+qxE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563F116BE06;
	Fri,  2 Aug 2024 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722617216; cv=none; b=RrdaG6ZlSSws915dQSiXpXRUb2mNaMT36Z0F2fjNGS/xBS6ighyz0gQ6Iqh+tdu1m1EVIOjUpRZTEYUjqt+wiRoJpL3Yt8jbynpDKrrWCDLZ32QXwzj14bR+0K04Dn6354IYkxolZd8WVeOwoY3uF+Np8ysgYuFPzFYBKsZxpg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722617216; c=relaxed/simple;
	bh=4y5k1QnCofmNxwcJVb7NvQqYIBcYJzenhBV6fF87API=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C3TpqtFT3UvAlwv4TjbpYLqx+2IuXqJcLm3xsA9Owxm0WIUVLnHWbqznul0BUWVxNgvEyFp7nhu/bE9nH061SEZCyBB2/0mXtwinaE/YZwG/+cev0I97/goXrod7aqOa3sAYvMe4KbNll6GS3gHEn4e1HOrbg11TWXB6Gahu2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWAD+qxE; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52f024f468bso11790481e87.1;
        Fri, 02 Aug 2024 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722617213; x=1723222013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8mY2dBkrjE8GweTAGavqDNNrZwpjLqK85WvRCvWyrxc=;
        b=BWAD+qxEtNI3BfuD+r1kWo1ARovSDlRDe9P65ri18RRZ83Kfc7mmCsbzBn+UxYV9mO
         vsnMJnh2xB28yGbE9RV1mPgCYnxJER3uM2zjqLZa33DMXLQ4gLVhDDwYzL7ozujSKC32
         pntDxtqyBh2jc/GnvOznIOJhN9g4zxzEEdOHXsy6J/KZhq30I1bpRQ0aMnoA14APUkLf
         jkb4oPO0vG+t12RTHkFGMtErxNRpYfMZO7zZboxsYR2z8ywLr29LUF2wA2PQOD3OoUrh
         fUtINeAmzlIbYn3FhUoaVUxEudiWrdz4vEd7Zl2hzvpU1NSn64RMCRoU/K3qGGWfTSOl
         iaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722617213; x=1723222013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8mY2dBkrjE8GweTAGavqDNNrZwpjLqK85WvRCvWyrxc=;
        b=GXo/ZhULTu/7epaXUtI/DSIbXSyUVjsRYAI4gR7qG0pIEp1GfTrqLiPTU9h3KYjsNi
         jcZIXgQidi7UD+La+SuTCL8s8pBleIsOKZ4RzGCxCDNRB/4c+K/JhIazpPUFfrMEa2HG
         JqPy97rpiguwhqRBs9w3JSv6vLhi6+wA8zZHnyXgLOEkgORpOG8PWxUgnckRO7GclOYp
         HjoHfISQtFQ1P4JEj5B9bqsOZHpVQK0E01cPqTYMYj9qi/Zn4oVhFUyRqv3qOgoT+/Nf
         C04flpbhudUlh0wkr5oJTPZ89alOYm7Sf/r0beKHVBsNaETJYS7NLyNmjqtssuzsUgyx
         WeJg==
X-Forwarded-Encrypted: i=1; AJvYcCXplmzwxk4GgxR0Ph1rqQPo5Y6Y4/8SKeK4xstKk4xl3vp1vrxbjggsJX63cSGDsSBSx71K+TXkPgNOGqaynZu05NQvW43R7a89G0l5
X-Gm-Message-State: AOJu0YyM6ANabWTjKL+O+Cc/lNwnE2oXmGFNgiExCADVXYFZ8UDOc99n
	UwFQLBJbkt1uv4dqqC2JES9W5x8Eba0LgKvXZpi9TKadgIL1B1my3Y3ViQ==
X-Google-Smtp-Source: AGHT+IHaWqMHJ46ZEkjg1WHLWXD8vKJ/XP5NqcSdc0QHWF0ZEz9Gn8kpcjvNQAqrFn48yT2Et79OWw==
X-Received: by 2002:a05:6512:281a:b0:52c:e3bd:c708 with SMTP id 2adb3069b0e04-530bb39d1f5mr2517293e87.10.1722617213052;
        Fri, 02 Aug 2024 09:46:53 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbcf1e97esm2318469f8f.37.2024.08.02.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 09:46:51 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 6.11-rc2
Date: Fri,  2 Aug 2024 18:46:36 +0200
Message-ID: <20240802164638.900157-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.11-rc2

for you to fetch changes up to 31634d7597d8c57894b6c98eeefc9e58cf842993:

  ceph: force sending a cap update msg back to MDS for revoke op (2024-08-01 13:14:28 +0200)

----------------------------------------------------------------
A fix for a potential hang in the MDS when cap revocation races with
the client releasing the caps in question, marked for stable.

----------------------------------------------------------------
Xiubo Li (1):
      ceph: force sending a cap update msg back to MDS for revoke op

 fs/ceph/caps.c  | 35 ++++++++++++++++++++++++-----------
 fs/ceph/super.h |  7 ++++---
 2 files changed, 28 insertions(+), 14 deletions(-)

