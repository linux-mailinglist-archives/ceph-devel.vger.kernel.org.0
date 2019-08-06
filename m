Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1D82A04
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 05:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfHFD1l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Aug 2019 23:27:41 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:53384 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHFD1l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Aug 2019 23:27:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id CC31A15F881;
        Mon,  5 Aug 2019 20:27:39 -0700 (PDT)
Date:   Tue, 6 Aug 2019 03:27:38 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@kernel.org>
cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, ukernel@gmail.com
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for reads
 and writes
In-Reply-To: <20190805200501.17905-1-jlayton@kernel.org>
Message-ID: <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>
References: <20190805200501.17905-1-jlayton@kernel.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddruddtledgjedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopehukhgvrhhnvghlsehgmhgrihhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 5 Aug 2019, Jeff Layton wrote:
> xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> to a file, and then reads back the result using buffered I/O, while
> running a separate set of tasks that are also doing buffered reads.
> 
> The client will invalidate the cache prior to a direct write, but it's
> easy for one of the other readers' replies to race in and reinstantiate
> the invalidated range with stale data.

Maybe a silly question, but: what if the write path did the invalidation 
after the write instead of before?  Then any racing read will see the new 
data on disk.

sage
