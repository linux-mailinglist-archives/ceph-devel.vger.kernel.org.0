Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF89105C9F
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 23:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKUWZL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 17:25:11 -0500
Received: from tragedy.dreamhost.com ([66.33.205.236]:51723 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfKUWZL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Nov 2019 17:25:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 11F9415F881;
        Thu, 21 Nov 2019 14:25:09 -0800 (PST)
Date:   Thu, 21 Nov 2019 22:25:08 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Muhammad Ahmad <muhammad.ahmad@seagate.com>
cc:     dev@ceph.io, ceph-devel@vger.kernel.org
Subject: Re: device class : nvme
In-Reply-To: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
References: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgudeivdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinheptggvphhhrdhiohdpghhithhhuhgsrdgtohhmnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adding dev@ceph.io

On Thu, 21 Nov 2019, Muhammad Ahmad wrote:
> While trying to research how crush maps are used/modified I stumbled
> upon these device classes.
> https://ceph.io/community/new-luminous-crush-device-classes/
> 
> I wanted to highlight that having nvme as a separate class will
> eventually break and should be removed.
> 
> There is already a push within the industry to consolidate future
> command sets and NVMe will likely be it. In other words, NVMe HDDs are
> not too far off. In fact, the recent October OCP F2F discussed this
> topic in detail.
> 
> If the classification is based on performance then command set
> (SATA/SAS/NVMe) is probably not the right classification.

I opened a PR that does this:

	https://github.com/ceph/ceph/pull/31796

I can't remember seeing 'nvme' as a device class on any real cluster; the 
exceptoin is my basement one, and I think the only reason it ended up that 
way was because I deployed bluestore *very* early on (with ceph-disk) and 
the is_nvme() detection helper doesn't work with LVM.  That's my theory at 
least.. can anybody with bluestore on NVMe devices confirm?  Does anybody 
see class 'nvme' devices in their cluster?

Thanks!
sage

