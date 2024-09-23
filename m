Return-Path: <ceph-devel+bounces-1816-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5C797E755
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 10:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7252815DA
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2024 08:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286951885BD;
	Mon, 23 Sep 2024 08:14:44 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E881885B3;
	Mon, 23 Sep 2024 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727079284; cv=none; b=Qtd62wJLjr+VBH0LHswbcht3CgyecstLsAR0oeavzBQcVbgwbRE3v94OCuZkhuF/pcCT9oDo7CsMDCQ0YS2682JHeAqzHG9xzK3ZXHXIvCRjgCPDXvAhvcSpjkW5JzdzoMDAU/cNtqVjJsobK+zGUo2A4JvCgQj675wUCZf8uGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727079284; c=relaxed/simple;
	bh=mZrSmMEhLS54H+lIyWQEQCE/6YN/Jq3+SronXI1rado=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxZKjUmmtYT+hefSIUv7tDACNzPKU22uj4/S+OS2T8qqh3ETM1cIrXHMurQwAYNnu/ZPZea3sW/4ikEp2cCPeBUm86mdoIkxQhepYABWPo41rfQMIiYZS0/mHaEiRVUnuwasQgXU5RY0tpToVdNXUa81r/O40j6qRczEde62kFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 99809481F5;
	Mon, 23 Sep 2024 10:06:36 +0200 (CEST)
Message-ID: <1690e7d0-6119-4fe3-a53b-d4977e7042a2@proxmox.com>
Date: Mon, 23 Sep 2024 10:06:35 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
To: Xiubo Li <xiubli@redhat.com>, David Howells <dhowells@redhat.com>,
 Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
 stable@vger.kernel.org
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
 <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
 <1679397305.24654.1725606946541@webmail.proxmox.com>
 <5335cdb5-7735-463e-907b-617774d6f01a@redhat.com>
Content-Language: en-US, de-DE
From: Christian Ebner <c.ebner@proxmox.com>
In-Reply-To: <5335cdb5-7735-463e-907b-617774d6f01a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/24 13:09, Xiubo Li wrote:
> 
> Sure, thanks in advance.
> 
> I will work on this next week or later because I am occupied by some 
> other stuff recently.
> 

There is some further information I can provide regarding this:
Further testing with the reproducer and the current mainline kernel 
shows that the issue might be fixed.

Bisection of the possible fix points to ee4cdf7b ("netfs: Speed up 
buffered reading").

Could this additional information help to boil down the part that fixes 
the cephfs issues so that the fix can be backported to current stable?

Regards,
Christian Ebner


