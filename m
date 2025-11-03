Return-Path: <ceph-devel+bounces-3911-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EA6C2E337
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 22:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 814BB3BD2CA
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 21:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AD02D660D;
	Mon,  3 Nov 2025 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbKEh1RZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31BB2BEC22
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762206825; cv=none; b=QHNtS7LF2Kz0Imk/zWN+3w3fWYArXnMhYFvNhW8+NsG4hb6Qp88Uwr/zqtCsQazWcfkSClXcK6nEK79Vl5FQK6w8ioqLv2vWcZF0UvKAzUH4Z+eQs9gYgF0W2Yc8180Cmv2Y1EolRsLTswscpBJlaRYmw2MTA6DxTUJQs7Y5tRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762206825; c=relaxed/simple;
	bh=mxI0YgSbQtMKOr0D2F+R3rQ1wslLsvwyS9QW6NTkc60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IQLpNte0higKqfseTVd+UU5rbLZdEvYm7xz4wL39ZtyGKqw3xrWwzsIqazu26Pl1nAzKdLbRP2Op7eKflMg57Pf+3h2GSoQMLPEJN/RUCTZ+Jj0PokmsGtISLEASma/2YwG71/eQr3ZmLeeMYs1fd+neuwR/Y++IDIahXWXYUDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbKEh1RZ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so3850887f8f.0
        for <ceph-devel@vger.kernel.org>; Mon, 03 Nov 2025 13:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762206822; x=1762811622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vsjqw+2IHrXcE0W5DFMVPj/vUMDhh4dGRku8NS0aLrU=;
        b=bbKEh1RZW7Di/F6EACspoTM3sfv7yHWizVHvTFtk9/RBA0aUDrbpwfEp9mxaLivQhR
         gdaYaX/G4w2KvZRqX7OwTPoNpGbVpRtrP+kdzFT0EuWssOHepPdlV4+Q2+klBr6d2iS0
         fc9akH+ymnbb3eUyBHzYUjKvFiMqpEdHGG+jYW8C0u9d24arV0GEKBtvEOb2+ps30kWH
         dEOOI/v9aNk9KSDnBP+g29nfmUKNATRkGdSfnQtCQYo2n8IvbuTmQgTfNOWGP24l7bNe
         k3UIR9c8ufYSMfcIvNGCA0E46AggvS6Gpyv0b2PCCX4lko2jH0lGDbmcIuPwv34bEo1W
         7XOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762206822; x=1762811622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vsjqw+2IHrXcE0W5DFMVPj/vUMDhh4dGRku8NS0aLrU=;
        b=WqxuCarAFTKeo8RdP4ztn78339Op4yshgYaSzMtIKsqkjnj6/gL83QEdC5p41jaMd4
         DJzwbZhHAnV0QFWCriCUQcOu+QKNZvAc8q0SZgdORGoyBB1t3xDuWXbAg8uAPySxhwhA
         60ZWlgl4hevMbKYt7HRgOZ3F4dwb0O+QPQdjStYSvtM2VWhhnKmhMNPsJDtiWimY4ECf
         pfnueaFYjaUSIlUnRNQeN+Tbsf5Xdk0T/I3LuRooq3vV+0VwpNjLuhRdwmefq4WwmwSN
         PJtRSXyQ+QW2k7dSVzTPyBbRg36n97tyO7wvag9mARPBBibRMNQWh7Uk73np0ImvsIAJ
         I+Jw==
X-Gm-Message-State: AOJu0Ywz2W20HxBWPgiIBTCpcyXqGa1N8yMJPoLD9lrzIF5W7UL3IC22
	xi+8tTIVuO/JiD6bZmHd53Xn1UQMJmx7Rie6t1cJ25WB5TxSFw2rM2asFtc/QA==
X-Gm-Gg: ASbGncuokcrzcFzR2xU4dzBK5wOUZ4Km7tkRlnikArebv7S8C+JDjFVnybpJnHwM0mW
	HRbd+fYyug3UV95bDYUX1l06G5PSrfDilCU/tXRKsoxu0ZKSRkSZM1liwPkZC3svmrYOKKxSphN
	DiFDXcz8LHCMRrznN59iifFYoWlDWWtMcyeO4h0bEBPy47gnEIQccWhWnSeqqdNLWifHi64VKIt
	laaO27f21Q8chWOTNeDikU3HJa8iUvtPtlKy1a65lfkVaS+70oJgX/yMtmmtjCD7drbGclKwo/C
	Z0rG2yZgwoqIlmZpSXlFx2nBO22Aal3EEFRNWcndZf+Va7C/47Ez8Teu6ntOYTjkAtczMuJF0eZ
	v9OW7CiFk2G1Z6eUNg+y+DqV62BosICF3ry19/Cel4gKBsWwJHWUHw89ZNZkfXTd00sFWq/YZHM
	8NhktJrHoVErdGEgMoimKDaqzi64Tb8w5vGZYE1DtW20Vu7TKoNA==
X-Google-Smtp-Source: AGHT+IH1twyI6QuOgHr5Mue/syApGbJumQxTz3oKMU59sYY4r6P1H3qduCG/XXxtSSBeIq8IQ+WKUw==
X-Received: by 2002:a5d:5d05:0:b0:429:d33e:def1 with SMTP id ffacd0b85a97d-429d33ee0e0mr4364663f8f.29.1762206821943;
        Mon, 03 Nov 2025 13:53:41 -0800 (PST)
Received: from zambezi.redhat.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efd3sm986521f8f.5.2025.11.03.13.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 13:53:41 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH 0/2] libceph: fix potential use-after-free in have_mon_and_osd_map()
Date: Mon,  3 Nov 2025 22:53:25 +0100
Message-ID: <20251103215329.1856726-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

As requested by Slava in [1], here is my version of the patch.

[1] https://lore.kernel.org/ceph-devel/5e6418fa61bce3f165ffe3b6b3a2ea5a9323b2c7.camel@ibm.com/

Thanks,

                Ilya


Ilya Dryomov (2):
  libceph: fix potential use-after-free in have_mon_and_osd_map()
  libceph: drop started parameter of __ceph_open_session()

 fs/ceph/super.c              |  2 +-
 include/linux/ceph/libceph.h |  3 +-
 net/ceph/ceph_common.c       | 58 +++++++++++++++++++++---------------
 net/ceph/debugfs.c           | 14 ++++++---
 4 files changed, 46 insertions(+), 31 deletions(-)

-- 
2.49.0


