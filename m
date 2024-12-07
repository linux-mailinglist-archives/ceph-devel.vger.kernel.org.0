Return-Path: <ceph-devel+bounces-2268-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2339E818B
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 19:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 251B41653E1
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 18:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8528D14F9D6;
	Sat,  7 Dec 2024 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/CMKcW8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB75B14B96E
	for <ceph-devel@vger.kernel.org>; Sat,  7 Dec 2024 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733595999; cv=none; b=RxYReNEGb2m6KWL697H3bjrXT/iJXOqhiK0WF5nlmlNdYtbi/kDzYmFsqKnvfb5XKQM8BajI+20vcCDe5Ny1UIF0VDjNLkhclC4JC5grgm5jP8keMVuZdZJiBEfBzDUPshiGjnmVwWN+DPJqYauxfX/kPxavI34ggaNn4+C/bDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733595999; c=relaxed/simple;
	bh=lDT25JweP+XOPZXpfHT5eKbuFtgDrqvJkS6hnb5ODTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8qLaqIKuxLERdh/dXaUyhlzRG1HSUCJsKUla6jzgQsqotH4GqYUsS3gGSTwpXgPVDz98lcl0FA5ERcjzR0WykOL+zT2VE6YXpiPgbJD6d3s/IyQT+gSt6znKWHlQ39ZPtp7iL/W6qxI+C1L1Rx1WK6w6ooUjDl5SCLCgSsTt5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J/CMKcW8; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3862d16b4f5so955050f8f.0
        for <ceph-devel@vger.kernel.org>; Sat, 07 Dec 2024 10:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733595996; x=1734200796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zSAQI7687IdQOmoh9N0AjVBaSXd0rUcuBbbPOeM/gNE=;
        b=J/CMKcW8rFv6u9pYe1KHIxMU2hBycWNt+69HFiUGgE2Muw2VwJ7pByEE/Qo3l1NyA7
         f/jU64NcEoqJosGk3IRLacYdNkqLO2tg0I35JQc5le1tcK75FceEkeo/3gtKCOCW1lfs
         xHaoCqjFrAHCSeMRIgqGNyOJtMI8uBavOpr7Yn4b7y5lAQGn0dzFHDI66QMdMQZLrqtI
         CU8dN1UyuOG1VOmxcxnQ9dxYsF57E+KpkA9XPkyFXoeAYq5ACIfYe8LTyzK/yagWzXhS
         B6KFngYt8gbySc4zo2gG9Ff5D0cgtndYDDunlhq8736Bfc+R8p+F7kLVO6Ufh/uMCCWc
         taxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733595996; x=1734200796;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSAQI7687IdQOmoh9N0AjVBaSXd0rUcuBbbPOeM/gNE=;
        b=DSI7jlXprmyzX/3RZeK3KFBvem4dq6VpDJiNpLhae/W4FpZ5rDQhYQ91W0GJxBNOny
         uX09pO6gwSP/CKlbKnFuluJ/EorjcjW4F+Pc9mNOwkqjwZ4GGZ+so2F5eeT6gg36vZHp
         G+sfFatvAUqKAOGbgLQ+I5enX8jHIhD0AYAAEs+bnyrohejhQWAJ3rV1KhU+fxA750zo
         zKwHEdqZjF5krnPTRfwYQt3B3sG7QA50W33bhjWAS8JAuw+1PrqVIuY4HI5TGOrSdstG
         SoLXmJyNo7pLLvYJ7HmMluULeaanrJYzFvPMxBkjMWiSNvonZeL5jZWpaA+xfjj+359Z
         EXsw==
X-Gm-Message-State: AOJu0YydQprRZ8Gl8wx2+PhsrN5b1EvAa9M/8JLX8EJrO4XBvKU4lbfk
	qWXlokm+hDC9PYpAky/TwVfP+9zq7N0xcr4BOKP6OBKrW0XobvxFNQbsdQ==
X-Gm-Gg: ASbGncthzxeGT3q1vpZJurroV08kkIfFNwO6yaC30+D+OkRrK/aBczniF6mYkoP8tTH
	Lm/HrlWiGmg2tHvJ5GweGs+dVQebnSTmsYVE1z7IxmGWxzYwscJfKyStD4sn76RDfYQoLjSFkD+
	vgSPRlOFAyj3Ps3Fx6e0ncdTuEahHwK5x8LfCgAiVOFuYhxHvlN4oac9HYwaTzBOuoZEVa74UVf
	U7bxOVx3bb2VARW2ZChdgYPQA7EK7RB9iODBGDOeNLJXArRRTVk7F2bc+MzBqtd4Yeo5OVwYSHe
	I65f8V+ykvklCM6S3Q==
X-Google-Smtp-Source: AGHT+IFwMVO9Hkq8iCJQWjtKLMkYU7qUUTrqd3ERaQclHET5r0P0tzo3wstxfAbIG7XkIsCluOimrQ==
X-Received: by 2002:a5d:64e7:0:b0:385:ee85:f1bf with SMTP id ffacd0b85a97d-3862a8b530bmr5497982f8f.18.1733595995727;
        Sat, 07 Dec 2024 10:26:35 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190989fsm7957386f8f.73.2024.12.07.10.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 10:26:33 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/2] ceph: ceph_direct_read_write() fixes
Date: Sat,  7 Dec 2024 19:26:17 +0100
Message-ID: <20241207182622.97113-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I noticed these while reviewing Max's fix for memory leaks in
__ceph_sync_read().

Thanks,

                Ilya


Ilya Dryomov (2):
  ceph: fix memory leak in ceph_direct_read_write()
  ceph: allocate sparse_ext map only for sparse reads

 fs/ceph/file.c        | 43 ++++++++++++++++++++++---------------------
 net/ceph/osd_client.c |  2 ++
 2 files changed, 24 insertions(+), 21 deletions(-)

-- 
2.46.1


