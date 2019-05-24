Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5929A27
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 16:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391598AbfEXOhX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 10:37:23 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:58822 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXOhX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 10:37:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 5214A15F8AC;
        Fri, 24 May 2019 07:37:22 -0700 (PDT)
Date:   Fri, 24 May 2019 14:37:20 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     "Robin H. Johnson" <robbat2@gentoo.org>
cc:     ceph-devel@vger.kernel.org, ceph-users@ceph.com
Subject: Re: [ceph-users] RFC: relicence Ceph LGPL-2.1 code as LGPL-2.1 or
 LGPL-3.0
In-Reply-To: <robbat2-20190510T200848-729932465Z@orbis-terrarum.net>
Message-ID: <alpine.DEB.2.11.1905162245580.24518@piezo.novalocal>
References: <alpine.DEB.2.11.1904221623540.7135@piezo.novalocal> <robbat2-20190510T200848-729932465Z@orbis-terrarum.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedgkedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquhhsvghrshestggvphhhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 10 May 2019, Robin H. Johnson wrote:
> On Fri, May 10, 2019 at 02:27:11PM +0000, Sage Weil wrote:
> > If you are a Ceph developer who has contributed code to Ceph and object to 
> > this change of license, please let us know, either by replying to this 
> > message or by commenting on that pull request.
> Am I correct in reading the diff that only a very small number of files
> did not already have the 'or later' clause of *GPL in effect?

To the contrary, I think one file (the COPYING file) has one line as a 
catch-all for everything (that isn't a special case) which is changing 
from 2.1 to 2.1 or 3.

https://github.com/ceph/ceph/pull/22446/files#diff-7116ef0705885343c9e1b2171a06be0eR6

> As a slight tangent, can we get SPDX tags on files rather than this
> hard-to-parse text?

(/me googles SPDX)

Sure?  The current format is based on the Debian copyright file format, 
which seemed appropriate at the time.  Happy to take patches that add more 
appropriate annotations...

sage
