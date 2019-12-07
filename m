Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900AE115B4B
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2019 07:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLGGCI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 7 Dec 2019 01:02:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43758 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfLGGCI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 7 Dec 2019 01:02:08 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1idTAH-0006SZ-5o; Sat, 07 Dec 2019 06:02:01 +0000
Date:   Sat, 7 Dec 2019 06:02:01 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v2 0/6] Delete timespec64_trunc()
Message-ID: <20191207060201.GN4203@ZenIV.linux.org.uk>
References: <20191203051945.9440-1-deepa.kernel@gmail.com>
 <CABeXuvpkYQbsvGTuktEAR8ptr478peet3EH=RD0v+nK5o2Wmjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvpkYQbsvGTuktEAR8ptr478peet3EH=RD0v+nK5o2Wmjg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 05, 2019 at 06:43:26PM -0800, Deepa Dinamani wrote:
> On Mon, Dec 2, 2019 at 9:20 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > This series aims at deleting timespec64_trunc().
> > There is a new api: timestamp_truncate() that is the
> > replacement api. The api additionally does a limits
> > check on the filesystem timestamps.
> 
> Al/Andrew, can one of you help merge these patches?

Looks sane.  Could you check if #misc.timestamp looks sane to you?

One thing that leaves me scratching head is kernfs - surely we
are _not_ limited by any external layouts there, so why do we
need to bother with truncation?
