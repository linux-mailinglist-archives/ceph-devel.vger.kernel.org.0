Return-Path: <ceph-devel+bounces-1542-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC0D938317
	for <lists+ceph-devel@lfdr.de>; Sun, 21 Jul 2024 00:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01C8DB20CDE
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Jul 2024 22:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5962182C7E;
	Sat, 20 Jul 2024 22:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabro.co.uk header.i=@nabro.co.uk header.b="OrnoTuTd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mta.nabro.co.uk (mta.nabro.co.uk [129.151.68.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF331E481;
	Sat, 20 Jul 2024 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.151.68.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721516219; cv=none; b=G2vhmrOTE8mZe5gIaHWnVkW9f2VAlo7UzODjeYMecDa5Q9RS9bcOfmmq077fYH9bV6jooCYbwfP73O3F73SjnN6UmBEwLdPhqeAobhCIvj4PqI13+kq6Vfg6+HusVxYePlDG52/83P3x0crZU3e2s0x3zKajSNyCQPEklPdATQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721516219; c=relaxed/simple;
	bh=KxHb4jUADVJR2G5hU7XpCHBLJlWyNDDYLVXGgnFfK1o=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=dtLX2JATB+C5OhEZ3nwG8C8lsdUDd+oaCieq2qLvANDDvFdsbCNLAdaF5xtpSW6d823tON/ZSI9usiPdXczVA8DW8EI25xmyl7SB1/rJmAVv/mCFffpk5zFq37bieheGjF6QWa4igFoOgtdtyxtSZnQOIyG5susXEudVviuLsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nabro.co.uk; spf=pass smtp.mailfrom=nabro.co.uk; dkim=pass (2048-bit key) header.d=nabro.co.uk header.i=@nabro.co.uk header.b=OrnoTuTd; arc=none smtp.client-ip=129.151.68.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nabro.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabro.co.uk
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E992ABE76C;
	Sat, 20 Jul 2024 23:48:40 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabro.co.uk; s=dkim;
	t=1721515724; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding:content-language;
	bh=lQBaP/4wldq/gHw3XMPV0yLWz7ojZ+zCf2VWGk1FQSw=;
	b=OrnoTuTdpoAw7P/vPlfNnwnq0ixtnF7Pt/ElflwlxPCGnl5L4b/Nq7H25Hn8lSTPqrbE+6
	4Ow8IMQUsfzHORQr6AsLEO1YqxmH6QwxYPphVzTdYm1sztwFekZFyNELi2zyd0LMxQ85RM
	TNquhf9ks47TSkLfq3HpYViPysEc8nX8Q9B9Txnod5210/698dDGTjDUjin0vfzRbl/s6M
	ffvPSVEalBiE0dWGlPZk8Uj+ZvYrvfoNZQPnCealDk4XDe6pbHt1/L5j/lpqissNoY5uYA
	FsDZ0hkkHizU1q8620K+xKjoEg80BwSB2yUnfrxfoYyfXeaBpZnW5gtXjAG/Og==
Message-ID: <94c6f4ac-193f-4fd4-8e6c-b0324a19c5a6@nabro.co.uk>
Date: Sat, 20 Jul 2024 23:48:41 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
From: Fmaster <fmaster@nabro.co.uk>
Subject: Possible kernel bug: Ubuntu Kernel linux-image-6.5.0-44-generic
 appears to have issues with fscrypt running on CephFS backend.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

More detail reported on Launchpad: 
https://bugs.launchpad.net/ubuntu/+source/linux-signed-hwe-6.5/+bug/2073679

No idea on the cause sadly.

Ty!


