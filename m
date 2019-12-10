Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8114B118AF9
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfLJOdE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Dec 2019 09:33:04 -0500
Received: from tragedy.dreamhost.com ([66.33.205.236]:45683 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfLJOdD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Dec 2019 09:33:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 9BCD415F89B;
        Tue, 10 Dec 2019 06:33:01 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:32:59 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Ilya Dryomov <idryomov@gmail.com>
cc:     Abhishek Lekshmanan <abhishek@suse.com>, ceph-announce@ceph.io,
        ceph-users <ceph-users@ceph.io>, dev@ceph.io,
        Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: v14.2.5 Nautilus released
In-Reply-To: <CAOi1vP8JyKzsc9mxHjMZWs_SaXQD7GrNbxRic9NvChxi_dUbow@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1912101432450.2897@piezo.novalocal>
References: <87sglscy4z.fsf@suse.com> <CAOi1vP8JyKzsc9mxHjMZWs_SaXQD7GrNbxRic9NvChxi_dUbow@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgieeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtoheptggvphhhqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> >   If you are not comfortable sharing device metrics, you can disable that
> >   channel first before re-opting-in:
> >
> >     ceph config set mgr mgr/telemetry/channel_crash false
> 
> This should be channel_device, right?

Yep!

	https://github.com/ceph/ceph/pull/32148

Thanks,
sage
