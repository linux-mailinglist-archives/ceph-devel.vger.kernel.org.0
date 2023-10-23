Return-Path: <ceph-devel+bounces-1-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5947D3CC6
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Oct 2023 18:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24D4FB20F39
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Oct 2023 16:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165FC1A5BC;
	Mon, 23 Oct 2023 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeXRNUIw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BE633C8;
	Mon, 23 Oct 2023 16:41:44 +0000 (UTC)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0849F8E;
	Mon, 23 Oct 2023 09:41:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E6C433C7;
	Mon, 23 Oct 2023 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698079302;
	bh=O3zoGBXVfb5WJW2MwxE5HShF9ljYkHcSyGRQbT2KEb8=;
	h=Date:From:To:Subject:From;
	b=YeXRNUIwm2ukIK/Xp2TQdb80JGAHUnPY71Q09TJnOej2KrxYIlxF/metEvCCdxuLJ
	 pHOw7zuNTfL0+BG+q2MSYIpj1zEwKm2bZIJv8CkBPVa5dlEx1hfo2as+qRXHNBLFWm
	 dRV0p/wqdLb0+g+ELazTpdSOZdj+Z/JYCL+JKRlI=
Date: Mon, 23 Oct 2023 12:41:41 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: audit@vger.kernel.org, autofs@vger.kernel.org, 
	backports@vger.kernel.org, ceph-devel@vger.kernel.org, cgroups@vger.kernel.org, 
	dash@vger.kernel.org
Subject: This list is being migrated to new vger infra (no action required)
Message-ID: <20231023-obscurity-bottom-1dc09c@meerkat>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello:

This list is being migrated to the new vger infrastructure. This should be a
fully transparent process and you don't need to change anything about how you
participate with the list or how you receive mail.

There will be a brief delay with archives on lore.kernel.org. I will follow up
once the archive migration has been completed.

Best regards,
Konstantin

