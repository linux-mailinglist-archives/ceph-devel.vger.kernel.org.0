Return-Path: <ceph-devel+bounces-1907-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3BCD99CBCC
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 15:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7AC4283CDB
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 13:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9D11537AA;
	Mon, 14 Oct 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="OYKL0oFj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A295672
	for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913594; cv=none; b=AEqktOPVioWB/TrDdhRvOusbgrXwg5txJvFzEZjVVmrmD0MReHL4etK0Le/my6YGNbvP5ROGxznECRjrtLETu3M3mbZjJHrndi9OjWp2hcoYhTEPwq3RUIo9+cLaXCwS4IPgRE03fZfkNhtIufmeS1g9WzK+r9keukxB9RdqMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913594; c=relaxed/simple;
	bh=/qI5UcMNRHR66S9xG4yowTz/slqyiym4+xUDmifwVCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YWE0huhbo/TQflrequpjnIsHpgWw2ebvrDrNNDM7RvROa0qrwI8putZ5YiZTfUIgbqG0u3tcWob2CBuQ5dK757FrE0KglO8/OCzc13PVfl5tlsVA+mwtwGNQ50siHQEzB/hAn+qUiyuDEeLDxpAsfma4BJuQl+9OMoNR1NqIDvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=OYKL0oFj; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6cbd57cc35bso39551126d6.1
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 06:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728913590; x=1729518390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=crqj33oZHxX79g7WIfZIRty3wF/s5+QQhWMYPqOuedM=;
        b=OYKL0oFj9Lp8Cij6UBXwAhgphRqppNuqwBOkdHRvDl6r3UqgLINm6Rq0CLpaNdrG+D
         773ShV4LZ1AaMMMsBH27lfYjhiRW1D91tDnr2pxTrvaLLZug9dOPADmDtXS9K7rgRIIi
         j8YXkVZHPe6nTf6HRXYcrMiKfRJ2wzs+BUOdge0fGnsOXgi+qshjtwN9Uj6G/B0eoZ7C
         dmwl3wxmTFurzwLkAzJPhFS5vqVVbTVdb4VISVgGo68oqEZ/aGokGEqzfzELDX17E559
         dVCT6Epw5UgHcviCyj7M1Tvo4XJ78ew+F3FBZmzyvdwZ1Z1IDuPH7dnNdC4NHU952UGJ
         QZvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728913590; x=1729518390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crqj33oZHxX79g7WIfZIRty3wF/s5+QQhWMYPqOuedM=;
        b=JdJqtraN+hm0EALS++zBGstgVP6GosdH432c1IgIPwK3jwO095aSjeQLwIYaPl0vdE
         pjbRBiMSzYVI/+NyYC6zOUCiM+x3hopIzyKziIzDzUtVV7MPv4anL1yJAcNh9Lx3wr0d
         WUjz3ezmFVSiRzoT50ZilAsTzPz/eik9SqR2SwYtpkmeHnSqU+Xa9TT9XVZh9Pv1EzFk
         e0Ry3Cxc6WmYoDe4GT98GsB9EgLkfUFTM+Q+RrUt7HKGRoY9XE9JTQ/UplCumqE+w3Q6
         8C3uqPtaNSZc3DVRLUpTAz3exJS/baU/3g7tq/UaChpK6NhgVrf+Hux9iYMwD7f9VYYl
         v1LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzwnMfT2pjY+/Ut4KJtrbyptGkn+gkgYVj5BFOzzQ2UFKCr4WGnRQd/ObR3TTjtN1EaqnpS2+RGjzx@vger.kernel.org
X-Gm-Message-State: AOJu0YzW+2z3Ja8jXxhp6Hbmo8Vb7ovGAyGSneorGAgNC0uObyXpesBZ
	ejdYTnq8LwZod6KT6wlrqa4cgHl9Z5dW912RgsQ1BtLLc9kox3rQVVLCAcan7w==
X-Google-Smtp-Source: AGHT+IEiC+HwEdLjgAYy8MxWH9fW+9EeCReHgvGFDOV5UFEUPy97V6+O/7xZcMFu75Yfallz1txEFA==
X-Received: by 2002:ad4:5f46:0:b0:6cb:440c:c44 with SMTP id 6a1803df08f44-6cbe52024a8mr256666466d6.1.1728913590195;
        Mon, 14 Oct 2024 06:46:30 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85a7700sm45584966d6.7.2024.10.14.06.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 06:46:29 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/2] ceph: use entity name from new device string
Date: Mon, 14 Oct 2024 09:46:22 -0400
Message-ID: <20241014134625.700634-1-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Respinning this because the last series accidentally included patches from
another set.

Patrick Donnelly (2):
  ceph: requalify some char pointers as const
  ceph: extract entity name from device id

 fs/ceph/super.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


base-commit: 7234e2ea0edd00bfb6bb2159e55878c19885ce68
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


