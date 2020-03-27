Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21ED91958B7
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Mar 2020 15:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgC0OOc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Mar 2020 10:14:32 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:36498 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgC0OOc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Mar 2020 10:14:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id CCB8215F89D;
        Fri, 27 Mar 2020 07:14:30 -0700 (PDT)
Date:   Fri, 27 Mar 2020 14:14:29 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Abhishek Lekshmanan <abhishek@suse.com>
cc:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: Re: v15.2.0 Octopus released
In-Reply-To: <878sjqc79i.fsf@suse.com>
Message-ID: <alpine.DEB.2.21.2003271410190.4773@piezo.novalocal>
References: <878sjqc79i.fsf@suse.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudehledgheelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecuffhomhgrihhnpegtvghphhdrtghomhenucfkphepuddvjedrtddrtddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdqmhgrihhnthgrihhnvghrshestggvphhhrdhioh
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

One word of caution: there is one known upgrade issue if you

 - upgrade from luminous to nautilus, and then
 - run nautilus for a very short period of time (hours), and then
 - upgrade from nautilus to octopus

that prevents OSDs from starting.  We have a fix that will be in 15.2.1, 
but until that is out, I would recommend against the double-upgrade.  If 
you have been running nautilus for a while (days) you should be fine.

sage


https://tracker.ceph.com/issues/44770
