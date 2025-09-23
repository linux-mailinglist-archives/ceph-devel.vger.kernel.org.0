Return-Path: <ceph-devel+bounces-3705-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67406B9576C
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 12:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0A22E5184
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 10:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF68302CA6;
	Tue, 23 Sep 2025 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tu-ilmenau.de header.i=@tu-ilmenau.de header.b="XL/+ytS+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-router1.rz.tu-ilmenau.de (mail-router1.rz.tu-ilmenau.de [141.24.179.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66875221F00
	for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.24.179.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624041; cv=none; b=l4leMiF9z47Hbw70FPE/pgzo6cWQ5ieVr7shmwUakUMF1TMGavN2Hj4VONfzZsAiO1Q96qCqKvZkSeuS6UcbPGL3yXZm9X1mKL3Gu0gO1EFiaMHeoBBFof2n6sI25ig4yX9r5EkKUOLlaY+yMmD2eRMWqDE6bTMahTD4i8inJE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624041; c=relaxed/simple;
	bh=K2WawpECvL3B/+4mspErYLijlHbTA+5LapGnyddXM9M=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=EXIQkPHWXV9HtxpNbswmwINRXZd7rRkL5tAkFiyhBGDz+/NFdRWs+95Uy4UMhKeR9+0z9+HCInqtfUL5B85GsAWijTB+sM9eEVvUq11BaagoO5CCjq7PWYCIsl/REeQ8ObZVQ/2+8U2gZaEFPeST+VdsAKvgwSV0CyiuQKktgvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tu-ilmenau.de; spf=pass smtp.mailfrom=tu-ilmenau.de; dkim=pass (2048-bit key) header.d=tu-ilmenau.de header.i=@tu-ilmenau.de header.b=XL/+ytS+; arc=none smtp.client-ip=141.24.179.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tu-ilmenau.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-ilmenau.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-ilmenau.de;
 i=@tu-ilmenau.de; q=dns/txt; s=tuil-dkim-1; t=1758623925; h=message-id
 : date : mime-version : to : cc : from : subject : content-type :
 content-transfer-encoding : from;
 bh=K2WawpECvL3B/+4mspErYLijlHbTA+5LapGnyddXM9M=;
 b=XL/+ytS+m2g5dNeXrLtNOCBzAh81Keaea+2qpyZ/QQ2kgvjYG5j04cpqIzR57W6ksym4P
 RmY/NMLI5QaA8I+XzGjD82nBnLvJoB2TA1og9TMQhymTsT9JHosLbnsWnm3g9Ev53ECiJUK
 wBGuluVLZluDJTituif5WKRm1mRmU6ooXSf9xL5ZDkmZXWiOdDlCNi8EbtsrLzKQrE4PQav
 YtCT/uABJ9w1IuQrIkmxYh3cxbcUco9k2xgrPy82sTSfppgC7jeinjcU5z1EP4pl1yC1m0X
 X0OD6cKTw5rikwmY5QdPBnJoE2QgooaSu+1xdcR0JX0dHb6Wviorj8/caHWg==
Received: from mail-front1.rz.tu-ilmenau.de (mail-front1.rz.tu-ilmenau.de [141.24.179.32])
	by mail-router1.rz.tu-ilmenau.de (Postfix) with ESMTPS id 480DE5FA8D;
	Tue, 23 Sep 2025 12:38:45 +0200 (CEST)
Received: from [141.24.212.106] (unknown [141.24.212.106])
	by mail-front1.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 2CACB5FC47;
	Tue, 23 Sep 2025 12:38:45 +0200 (CEST)
Message-ID: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
Date: Tue, 23 Sep 2025 12:38:44 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org
From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Subject: [bug report] rbd unmap hangs after pausing and unpausing I/O
Autocrypt: addr=raphael.zimmer@tu-ilmenau.de; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I encountered an error with the kernel Ceph client (specifically using 
an RBD device) when pausing I/O on the cluster by setting and unsetting 
pauserd and pausewr flags. An error was seen with two different setups, 
which I believe is due to the same problem.

1) When pausing and later unpausing I/O on the cluster, everything seems 
to work as expected until trying to unmap an RBD device from the kernel. 
In this case, the rbd unmap command hangs and also can't be killed. To 
get back to a normally working state, a system reboot is needed. This 
behavior was observed on different systems (Debian 12 and 13) and could 
also be reproduced with an installation of the mainline kernel (v6.17-rc6).

Steps to reproduce:
- Connect kernel client to RBD device (rbd map)
- Pause I/O on cluster (ceph osd pause)
- Wait some time (3 minutes should be enough)
- Unpause I/O on cluster
- Try to unmap RBD device on client


2) When using an application that internally uses the kernel Ceph client 
code, I observed the following behavior:

Pausing I/O leads to a watch error after some time (same as with failing 
OSDs or e.g. when pool quota is reached). In rbd_watch_errcb 
(drivers/block/rbd.c), the watch_dwork gets scheduled, which leads to a 
call of rbd_reregister_watch -> __rbd_register_watch -> ceph_osdc_watch 
(net/ceph/osd_client.c) -> linger_reg_commit_wait -> 
wait_for_completion_killable. At this point, it waits without any 
timeout for the completion. The normal behavior is to wait until the 
causing condition is resolved and then return. With pausing and 
unpausing I/O, wait_for_completion_killable does not return even after 
unpausing because no call to complete or complete_all happens. I would 
guess that on unpausing some call is missing so that committing the 
linger request never completes.

 From what I am seeing, it seems like this missing completion in the 
second case is also the cause of the hanging rbd unmap with the 
unmodified kernel.


Best regards,

Raphael

