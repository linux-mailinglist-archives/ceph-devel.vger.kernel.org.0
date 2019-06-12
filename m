Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75AF429E8
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436945AbfFLOuX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jun 2019 10:50:23 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:44437 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409303AbfFLOuX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jun 2019 10:50:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 2DF8E15F883;
        Wed, 12 Jun 2019 07:50:22 -0700 (PDT)
Date:   Wed, 12 Jun 2019 14:50:20 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org, ceph-users@ceph.com
Subject: Re: RFC: relicence Ceph LGPL-2.1 code as LGPL-2.1 or LGPL-3.0
In-Reply-To: <alpine.DEB.2.11.1904221623540.7135@piezo.novalocal>
Message-ID: <alpine.DEB.2.11.1906121446570.4977@piezo.novalocal>
References: <alpine.DEB.2.11.1904221623540.7135@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudehjedgkeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquhhsvghrshestggvphhhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 10 May 2019, Sage Weil wrote:
> Hi everyone,
> 
> -- What --
> 
> The Ceph Leadership Team[1] is proposing a change of license from 
> *LGPL-2.1* to *LGPL-2.1 or LGPL-3.0* (dual license). The specific changes 
> are described by this pull request:
> 
> 	https://github.com/ceph/ceph/pull/22446
> 
> If you are a Ceph developer who has contributed code to Ceph and object to 
> this change of license, please let us know, either by replying to this 
> message or by commenting on that pull request.
> 
> Our plan is to leave the issue open for comment for some period of time 
> and, if no objections are raised that cannot be adequately addressed (via 
> persuasion, code replacement, or whatever) we will move forward with the 
> change.

We've heard no concerns about this change, so I just merged the pull 
request.  Thank you, everyone!


Robin suggested that we also add SPDX tags to all files.  IIUC those look 
like this:

 // SPDX-License-Identifier: LGPL-2.1 or LGPL-3.0

This sounds like a fine idea.  Any takers?  Note that this can't replace 
the COPYING and debian/copyright files, that latter of which at least 
is needed by Debian.  But additional and explicit license notifications 
in each file sounds like a good thing.

Thanks!
sage

