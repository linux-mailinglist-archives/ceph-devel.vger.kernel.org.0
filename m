Return-Path: <ceph-devel+bounces-1870-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B95F98DC76
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Oct 2024 16:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B061F27152
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Oct 2024 14:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AE51D07A0;
	Wed,  2 Oct 2024 14:35:12 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12A1D1509;
	Wed,  2 Oct 2024 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879712; cv=none; b=buzgO5qONONQVOA3D0eJc6iXKEexgoYF6s8JQ+hvbR7sI5sxLiwUZ+qL9RRvGUzLCoMjndaxry//OvSAQWVKoSjxRyTFpdX3oDva3YRVAjH4eJ3lCRC48f05CT/1Magnixi0w9tDOLGYNWZ2RmLKB/klFKHdLAmouJtkoSZ58WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879712; c=relaxed/simple;
	bh=T2vtcsV22XMU6128dIVVPH5EIQYFYg4R5rnjtO84s64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mv1vO7HB6CnHU5ylBVvJzSlmaP9jphgJnTYlffPChkG6CLpc4g/HKgfYiMClEOQab/7RzDz5OV6l8L9lQuMZbyc//lnJfRID7NwQS+GBxkHRMojQaMpRt9LPLX6uAfe5Rwd7sQII24WIMskrOTN3wUA7gflvPb8VqRGjn28eJao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 222DA43445;
	Wed,  2 Oct 2024 16:28:30 +0200 (CEST)
Message-ID: <8b24d0d8-7e94-42eb-9fdd-c3c2e8a44c3d@proxmox.com>
Date: Wed, 2 Oct 2024 16:28:28 +0200
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
Content-Language: en-US, de-DE
From: Christian Ebner <c.ebner@proxmox.com>
In-Reply-To: <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I can report some progress on this issue and attached a possible fix to 
current stable as patch to the issue at 
https://bugzilla.kernel.org/show_bug.cgi?id=219237

Is this the correct approach for a fix?

I noticed the tail clear flag being set in the requested netfs traces 
for the subreq leading to the corrupt all zero contents being read.


Best regards,
Christian Ebner



