Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A542C15EF
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Sep 2019 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfI2PaU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Sep 2019 11:30:20 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:42195 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfI2PaU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Sep 2019 11:30:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 5775015F87A;
        Sun, 29 Sep 2019 08:30:19 -0700 (PDT)
Date:   Sun, 29 Sep 2019 15:30:17 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Xuehan Xu <xxhdx1985126@gmail.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Subject: Re: Why BlueRocksDirectory::Fsync only sync metadata?
In-Reply-To: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1909291528200.5147@piezo.novalocal>
References: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrgedtgdelvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopeguvghvsegtvghphhdrihhonecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 29 Sep 2019, Xuehan Xu wrote:
> Hi, everyone.
> 
> I'm trying to read the source code of BlueStore. My question is why it
> is sufficient to only flush the log in BlueRocksDirectory::Fsync?
> Shouldn't it flush the file data first? Is it because rocksdb always
> flush file data before doing fsync? Thanks:-)

My recollection is that rocksdb is always flushing, correct.  There are 
conveniently only a handful of writers in rocksdb, the main ones being log 
files and sst files.

We could probably put an assertion in fsync() so ensure that the 
FileWriter buffer is empty and flushed...?

s
