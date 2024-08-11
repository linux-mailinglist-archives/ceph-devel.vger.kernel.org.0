Return-Path: <ceph-devel+bounces-1650-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3261494E329
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 22:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF984281062
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 20:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8B915C120;
	Sun, 11 Aug 2024 20:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAumNzNI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662D8F47;
	Sun, 11 Aug 2024 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723409875; cv=none; b=rlD0AAlAJlifptkUWGmHoVFL7d5qlvpV5Dv0np/J/C8x4yH6ClLS/N2+uSocUeI0b4Kx9nBLPyz9Xf9Dc+ZweA2IC1RYn1MQhaD7WwHe4g1GExhJ1rR0xQ6BuLe7PlmTVpUkD3i9m3AjJjVJgE3jlFylybWNAV39NqL4aGJ7fHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723409875; c=relaxed/simple;
	bh=t3DhI0jMTj4Ni02MAmr0uBN4yMx/G+0wYr56cMRafrk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KrifUXLWMxSzekoJGnWVVNAAHz6TgwfC51jd3NsWcPm4mt2a8yzZH6XLoGizDXCpEQSCbwgiEA63U+DXIY21pDcRdYsVjr7yI3Y6Lp38bDwPye2w5t4oiz3IKkLz0qu5WXw7VuES1cqy2vGvMvYMPLnym+x48Skgc2/ydgZRklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bAumNzNI; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-685cc5415e8so37981047b3.3;
        Sun, 11 Aug 2024 13:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723409873; x=1724014673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3DhI0jMTj4Ni02MAmr0uBN4yMx/G+0wYr56cMRafrk=;
        b=bAumNzNIsNMS+JtvQtlSLnMfzNmRmldrIrQrtyOjH2xD1LjTd6MLmMJiRQNGzVuo3W
         wTF8BKBmDEfw5Vp3ZvC4JklwsBZewJx8bZnu+VvWwtGBApg3cHOTfkakH+EGQX7uFjlf
         9BUmjhNIkuGbdZNs/5ibvKIvUvb8J/kKj/suGnmzceU4K28Kl4vHrMaMUO7zlwX08DJI
         tRJ5WGiVYhZWQFHdJ1xghGsKa/uy2APu3cde/Zj19mYEH0d8mftKnGX6eo7hUb12N8kP
         Js7TfQvS7qdEB3RAptKaWKYGUs3uaLwqTvFdzvl4TaMgsQ9nOWtSrnL7yN1wHM7g/lRf
         vytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723409873; x=1724014673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t3DhI0jMTj4Ni02MAmr0uBN4yMx/G+0wYr56cMRafrk=;
        b=XGFWJh+GZKDsrJRgWLetLcUPw5DAGEFuzPGceaBdLr9UHJV4mBtii3NuCDXl98WvKD
         1YFkxdbECmGgL3UUU1uDWR8CGmAp8YyUqD9f++z+RyJ+EOEz4vnF0NWdcoQDGKxzZcXl
         f4cgv0Ly3IuRCXrrxqy9s7E6GwfU3r7QZZief/Qoknr+CbYaw4na7GAz0pMOCJQJ8E6T
         NA9y7Ue6mDuQ8ofyZ4ZGwh4OYb2SwJDY4Yu5tMWr5ltg+2kDQPStp9VkU88lmKgs0QQT
         2WxwKyN4xiiC0wnLtmsm8iN2Iukq9FYG1gYGAy5PwKVolT9FPMG6HdWQ8YjoZswSxii4
         wkcg==
X-Forwarded-Encrypted: i=1; AJvYcCW3XuQnDZ1eKW8gXwJtc3zCtaRun1j/EMJAe+/ViR5np8ImyTzuTuxY+CPCFKqLp8n5b/SgfekO@vger.kernel.org, AJvYcCX1g8B+N3HwyndNMKOJkSkDz6hlJlCZGfynsloy85h8m+bwBAq/iq/soG5InZmp0ab6ixg6Cmy5Hhgn+cQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrHODmJvrZtWnVR/udvXyZXGBEcIdVBqH8Ni9IGJK7DWHfvos+
	Qsf3h8CMG9XCzcEsWPKgOw3V51tEJddbl8zleAvZPHaclsdQA7kk
X-Google-Smtp-Source: AGHT+IH7E7MaTbLeBJJxHYmmp6f6nAwbH5bzPSGFKtD6G2Uabyt2FwSv5McC1COIO/sogIvJCU5KNg==
X-Received: by 2002:a05:690c:389:b0:627:24d0:5037 with SMTP id 00721157ae682-69ebf484afemr112314207b3.0.1723409873207;
        Sun, 11 Aug 2024 13:57:53 -0700 (PDT)
Received: from dev0.. ([2405:201:6803:30b3:6c2e:a6d:389a:e911])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb900360sm25868695ad.92.2024.08.11.13.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 13:57:52 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: jain.abhinav177@gmail.com
Cc: ceph-devel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	idryomov@gmail.com,
	javier.carrasco.cruz@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	skhan@linuxfoundation.org,
	xiubli@redhat.com
Subject: Re: [PATCH net] libceph: Make the input const as per the TODO
Date: Mon, 12 Aug 2024 02:27:46 +0530
Message-Id: <20240811205746.1089180-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240811193645.1082042-1-jain.abhinav177@gmail.com>
References: <20240811193645.1082042-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I realised that I made a bit of mistakes while sending this patch and hence
I have sent a v2. Kindly check v2 here:

lore.kernel.org/all/20240811205509.1089027-1-jain.abhinav177@gmail.com
---

