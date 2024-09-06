Return-Path: <ceph-devel+bounces-1792-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CA696EBC0
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 09:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DCB7283D6C
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 07:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1973A40879;
	Fri,  6 Sep 2024 07:15:57 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B513B7A6;
	Fri,  6 Sep 2024 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606956; cv=none; b=qzjW8SoFCC4qvjwJNMsYgXuP9aZP3zqDPvgpmgFV35cLeQqz5JYaZMem0cbtI27EkmrS0ZnpWpI1yigI6z/9F011CCUp850XYi+wGBu4JPC04SkFZGyMV9uWBdHDCc7oLFjTd+B2OjpKzFdNKcFeYzY+KEH5YfC8aNdIawghF0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606956; c=relaxed/simple;
	bh=hdP07BeDVLYJXc6FZnBRqQoVhLrlnPPQMX6uR1xlb6o=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=udV9nTd7CYp2vdhx8WGl4XIHD7qhqcIc+GNDD+WGjFsWFlMDnXNAVWtIanaz5pFHeueejOtDLUjNPCpSvzmlSXZD6NuIfjSytgJ1nNqMV7lNUNsFzD8Yl31alrRrSetJPNkdsJEiPCoJmyPtp2JE39rwq7ECu+stHoGDqx5Nnzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 3CC6C451B7;
	Fri,  6 Sep 2024 09:15:47 +0200 (CEST)
Date: Fri, 6 Sep 2024 09:15:46 +0200 (CEST)
From: Christian Ebner <c.ebner@proxmox.com>
To: Xiubo Li <xiubli@redhat.com>, David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
	stable@vger.kernel.org
Message-ID: <1679397305.24654.1725606946541@webmail.proxmox.com>
In-Reply-To: <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
 <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev67
X-Originating-Client: open-xchange-appsuite

> On 06.09.2024 03:01 CEST Xiubo Li <xiubli@redhat.com> wrote:
> 
>  
> Hi Christian,
> 
> Thanks for reporting this.
> 
> Let me have a look and how to fix this.
> 
> - Xiubo
> 

Thanks for looking into it, please do not hesitate to contact me if I can be of help regarding debugging or testing a possible fix.

Regards,
Christian Ebner


