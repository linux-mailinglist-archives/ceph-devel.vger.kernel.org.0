Return-Path: <ceph-devel+bounces-1548-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E506D93A162
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 15:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9491A1F22DEF
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 13:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EA1152E1D;
	Tue, 23 Jul 2024 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fWxhmD6y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17173208A0
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721741453; cv=none; b=MoDmZO+RhwzkrelaGedak6tuyjisT2S5yZyQlkDt0Fj2uHaRK2qhojsoa9XsohiIY6MqOAXWE205+jKbNudm9YI2eNtbIGdbvAsuQdK+lkvMSO0g1vRu7HX0fyDvl0MCsq2QOcVVqkepcq5OfM3oXwTmZ8bCfQUedkqgignMPgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721741453; c=relaxed/simple;
	bh=mjxfhNWSDEtrj0+ZM4ZinQDzjr3OdStCoz4kzstLYFk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Gv5F4Bdv8gkSTdRbD3K5co2c+KGVnoc86QARRmn+cHbD1ZoSiKc48VHMl19o4deQZwZmMehFvnwOVoNsokc12uI1GXA6bL8ibQknaXi80Oja0gQKU43BYTkibvXBxZx6DD7Ab5+3lZzyGkY3hB5I/H1zJO3wecGPpICERuKtnok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fWxhmD6y; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2cb6b247db0so590241a91.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 06:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721741450; x=1722346250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqlR1BIutPkgOwMCyULXWeyxag7BhJk90RFsq6PrQZo=;
        b=fWxhmD6yDBR1vYuMmy01EgxXRAoa5HPs70nfgAbdkgzYq94B8SMJAnwlhkXAhOzl3f
         S5PyjphumEvwN0bRlwKbLBjnQuJehQda+38lFxyktv3c1i5ukaatQV8vFOjixvQCUYlH
         CTnZd6jWupTdhd1xcco8TJ+3bt8NCMpgYaaec7YrehoMR1Gqg1M6zXu/bGFOdIB5VZVg
         3YsAOnbTRfZGAFDh/JJt68W8oD95bgLl1AH+feLyjzpVSbFpZ7IpfjUVRDkHhGk90XUE
         RtS9K4fvIeR59smFnQfAgwH59Uk/KxHGSptzZe245KVUxuHdQYdzzodNcG3to8skneP3
         taGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721741450; x=1722346250;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqlR1BIutPkgOwMCyULXWeyxag7BhJk90RFsq6PrQZo=;
        b=UJsnzClvLwz4VtyyxAcrpAgKG/ZmxwtvbFXTB0D8nFUH1+w9/stuyfwZRKukVyUk3+
         zQPXz0MtOpsIcqp1vya4y6q/09KRw0OQUzbrALXI4bX5/HrrfvESw9kzwZvcSOFnxFpa
         gQwtFjMIGItNT6DFABhSJKSz1Th+/SQ0q2bmXEJZdh/mYAQVHLqaQu2XOibmCoeJW7gF
         3oOwh/tY154rHANzUTDxeASa8JzHXY+hM9ng0jE1uLMHwU47qNNRV51sVRbvqBx03/JO
         Y5SkVb72eG29gFcyA4P22L1OqW704E+S1mGAGW2v+Mcpr1DS+hjNUK3vLvrBkcC80nSE
         v2kA==
X-Forwarded-Encrypted: i=1; AJvYcCXoTNcro+Vf/VcEyCC6UtccdX78hb1tz4Vdpw7vC8HGwjPKWEEioGifhqPuENugp5ZUWsYK4H8XDBwL@vger.kernel.org
X-Gm-Message-State: AOJu0YzYP8osFCg/BUcZfoa1W3mpHTBRCLDQWf2TY2RkC75jtCL/LDsu
	vLOv8chbIzJtnSfw+w4WjxXyYknyO/K1BgF/PUBU3K13mzT7iqSNN/liGnwH6FgLk68zX8IGDUO
	se6E=
X-Google-Smtp-Source: AGHT+IHDM+Qmjw2gX4WFG+25cSaQly4nclkewYqx2IYKX4yl9o3sdW7TdNziDSTE7eR/4EF9vuEw/A==
X-Received: by 2002:a17:90b:494:b0:2cd:1e0d:a4c8 with SMTP id 98e67ed59e1d1-2cd1e0da5ffmr7298722a91.3.1721741449707;
        Tue, 23 Jul 2024 06:30:49 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cd8cfb85c0sm1553157a91.0.2024.07.23.06.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 06:30:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: davem@davemloft.net, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org, 
 ceph-devel@vger.kernel.org, Ofir Gal <ofir.gal@volumez.com>
Cc: dhowells@redhat.com, edumazet@google.com, kuba@kernel.org, 
 pabeni@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com, 
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
In-Reply-To: <20240718084515.3833733-1-ofir.gal@volumez.com>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
Subject: Re: [PATCH v5 0/3] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-Id: <172174144805.171126.5886411285955173900.b4-ty@kernel.dk>
Date: Tue, 23 Jul 2024 07:30:48 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Thu, 18 Jul 2024 11:45:11 +0300, Ofir Gal wrote:
> skb_splice_from_iter() warns on !sendpage_ok() which results in nvme-tcp
> data transfer failure. This warning leads to hanging IO.
> 
> nvme-tcp using sendpage_ok() to check the first page of an iterator in
> order to disable MSG_SPLICE_PAGES. The iterator can represent a list of
> contiguous pages.
> 
> [...]

Applied, thanks!

[1/3] net: introduce helper sendpages_ok()
      commit: 80b272a6f50b2a76f7d2c71a5c097c56d103a9ed
[2/3] nvme-tcp: use sendpages_ok() instead of sendpage_ok()
      commit: 41669803e5001f674083c9c176a4749eb1abbe29
[3/3] drbd: use sendpages_ok() instead of sendpage_ok()
      commit: e601087934f178a9a9ae8f5a3938b4aa76379ea1

Best regards,
-- 
Jens Axboe




