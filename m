Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DFC438EB
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbfFMPJw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 11:09:52 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:36820 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732341AbfFMN4K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jun 2019 09:56:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 2556C15F88E;
        Thu, 13 Jun 2019 06:56:09 -0700 (PDT)
Date:   Thu, 13 Jun 2019 13:56:07 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Kai Wagner <kwagner@suse.com>
cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: Re: octopus planning calls
In-Reply-To: <17f88e39-45d7-d13b-0c42-db1f07195c26@suse.com>
Message-ID: <alpine.DEB.2.11.1906131354420.12100@piezo.novalocal>
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal> <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal> <alpine.DEB.2.11.1906111326130.32406@piezo.novalocal> <alpine.DEB.2.11.1906121438520.4977@piezo.novalocal>
 <17f88e39-45d7-d13b-0c42-db1f07195c26@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudehledgjedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpegslhhuvghjvggrnhhsrdgtohhmpdihohhuthhusggvrdgtohhmpdhtrhgvlhhlohdrtghomhenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtohepuggvvhestggvphhhrdhiohenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 13 Jun 2019, Kai Wagner wrote:
> On 12.06.19 16:41, Sage Weil wrote:
> >>   1600 UTC  RBD             https://bluejeans.com/878018659
> > 	recording: https://www.youtube.com/watch?v=vO86xmbpo-k
> Is there also a pad available?

Nope-- the output from the planning is the trello board at

	https://trello.com/b/ugTc2QFH/ceph-backlog

and specifically the RBD list.  For the RADOS disucssion, it's the RADOS, 
bluestore, mon, mgr, and messenger lists.

The purple 'Octopus' labels are the items that are currently flagged as 
in-scope for octopus.

Now we just need to figure out if that means November or March... :P

sage
