Return-Path: <ceph-devel+bounces-1526-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A5692FECA
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 18:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F8631F22B8C
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2024 16:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD1817625F;
	Fri, 12 Jul 2024 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+ZQgXm/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C7B176224;
	Fri, 12 Jul 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720802886; cv=none; b=Dau8NQlOnPrb5GVZUeWSBZZNLVx7r0uZnZDK3xPULWL5JQogFWk6VHwDPrvo0NwxfVm3eYXH7iT/lTn2cHfoGCOTTj+w+HuJO1+UrwwOw7bpTisHONdv9ZbNQKK0eGxseYhUGA0ZsE+TV79rr6oJ6JfPTs3vCneOhPgFtmE3njg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720802886; c=relaxed/simple;
	bh=RC2e7WlLSP3cm67j7LA8pW+VkQvhZE2UsAslIPnndY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dCNecCmHtawmF5pTuIcdqjhkja8JPNYhouILualus3YC6ZrIUdp6ijjrpN7FGjQPE443IOXMNHyVD2CMk26CdpJOYEMjz06L63pM0emGamOQZ5GGP3aYe5OU/Yn/sigqzhKLnoD2FCKYdANtVPeMcuCY1J1HgX+olZNZwBAIQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+ZQgXm/; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ec61eeed8eso28548441fa.0;
        Fri, 12 Jul 2024 09:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720802883; x=1721407683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2/U3UtAsmtilaeUJhnEMoOOpsbq+nGei+Pt062zxp4s=;
        b=Q+ZQgXm/wKOITTJrbPbKD70Tm1V2H+YxM0TMIW0kqU/jsvLRu3kQAKpfWEVlD9JONK
         DMV0R7xG2IUg2OEBnUSoutdo9MlGRnIzxQVMbrbpH2ibzhsgzmQyoLMsIdyBaMm8fRd+
         9JvTg/5C8ghwZUne7JU7srEhbz0DSuaVn/Waodhp4aJOzvA/A5ol4A0MMG+t7xZiE65p
         8851NQpnmqcsSD2xJht/UjKzJquB66cRdrTtjNFffw9BvC2Ar6Z5TpvJzDXJUcwtSlJF
         YLLZ/2zp/C+fN7HuXEqO0LHIZxWWnqHa1mD+PLQvF5G3emTbCtfnX9WC2e05uNoOiRWP
         P33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720802883; x=1721407683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2/U3UtAsmtilaeUJhnEMoOOpsbq+nGei+Pt062zxp4s=;
        b=mfSzGeHRKP9hOmC4wW14EAYMp9VqZaX7j4Vyymnp7LHDp+3y471x6VeUUwLePQBeiJ
         59rFcnsV4VdkXRYW97a3B3vvJf+RHf8YroINPLwlf1sNCMoTLpiEHYreMnq5jdk0R4OK
         wfxDRrC9zOxVu9SJzgxwZdg3Zxoy//kTW16qlObbYt25+p9MwC3FZn4EIyWGfwstEsjQ
         i+vYUDFSCjAw3qVWBj9a9NOsVBkubbmTZQlWI9L7Nq2ofrfeeb/VS5lMds+7j3K1zqJD
         R+zKHl4K2NPCS3HTBaH8iK391uaSu+Zvnbb+CXQBQdMXMiNoa4RuN3iKlz1FGV9iIdnZ
         vmTg==
X-Forwarded-Encrypted: i=1; AJvYcCUCaiztMlmYSzo7z7PACSSbFhi+kwwPwkYNhky79lHylzm4z/6duFNyudI7SJj7NyF94O9nzVpKSGo88lBiTM80+8acUL9P8ocSDHrz
X-Gm-Message-State: AOJu0YwSNnl4SRJutzjY6DyfJfaXsUeeuFTT9reWEN/Ma+KoGTF6H9Nn
	y/6+wQB/8cS9GlPBR31zDklUcV0UZviQkXOvhRXvrQzpmyTTebAB0EDl/Q==
X-Google-Smtp-Source: AGHT+IGkaWht7sdKU8fH2BOaUvy9YY+CJ+N3osVpyEIVYDXuX1VYSjE1KbZ7ZamYbCHmcrW8iY3vEQ==
X-Received: by 2002:a2e:9b0f:0:b0:2ec:3e02:972a with SMTP id 38308e7fff4ca-2eeb30bba8bmr76303221fa.11.1720802882883;
        Fri, 12 Jul 2024 09:48:02 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfab0fbsm10524210f8f.95.2024.07.12.09.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 09:48:02 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 6.10-rc8
Date: Fri, 12 Jul 2024 18:47:43 +0200
Message-ID: <20240712164745.409957-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

The following changes since commit 256abd8e550ce977b728be79a74e1729438b4948:

  Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-6.10-rc8

for you to fetch changes up to 359bc01d2ecc9093216d21cfa03a545c44413cb6:

  libceph: fix crush_choose_firstn() kernel-doc warnings (2024-07-11 16:33:07 +0200)

----------------------------------------------------------------
A fix for a possible use-after-free following "rbd unmap" or "umount"
marked for stable and two kernel-doc fixups.

----------------------------------------------------------------
Ilya Dryomov (1):
      libceph: fix race between delayed_work() and ceph_monc_stop()

Jeff Johnson (2):
      libceph: suppress crush_choose_indep() kernel-doc warnings
      libceph: fix crush_choose_firstn() kernel-doc warnings

 net/ceph/crush/mapper.c |  7 +++++--
 net/ceph/mon_client.c   | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

