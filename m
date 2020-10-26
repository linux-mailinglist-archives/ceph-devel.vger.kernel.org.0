Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DF9299359
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Oct 2020 18:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787165AbgJZRGu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Oct 2020 13:06:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:56888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1734631AbgJZRF3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 13:05:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36963ACD8;
        Mon, 26 Oct 2020 17:05:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C43ADDA6E2; Mon, 26 Oct 2020 18:03:54 +0100 (CET)
Date:   Mon, 26 Oct 2020 18:03:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dsterba@suse.cz, linux-fsdevel@vger.kernel.org, ericvh@gmail.com,
        lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Promote to unsigned long long before shifting
Message-ID: <20201026170354.GR6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-7-willy@infradead.org>
 <20201026163546.GP6756@twin.jikos.cz>
 <20201026164442.GU20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026164442.GU20115@casper.infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 26, 2020 at 04:44:42PM +0000, Matthew Wilcox wrote:
> On Mon, Oct 26, 2020 at 05:35:46PM +0100, David Sterba wrote:
> > On Sun, Oct 04, 2020 at 07:04:27PM +0100, Matthew Wilcox (Oracle) wrote:
> > > On 32-bit systems, this shift will overflow for files larger than 4GB.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > ---
> > >  fs/btrfs/raid56.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > > index 255490f42b5d..5ee0a53301bd 100644
> > > --- a/fs/btrfs/raid56.c
> > > +++ b/fs/btrfs/raid56.c
> > > @@ -1089,7 +1089,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
> > >  	u64 disk_start;
> > >  
> > >  	stripe = &rbio->bbio->stripes[stripe_nr];
> > > -	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
> > > +	disk_start = stripe->physical + ((loff_t)page_index << PAGE_SHIFT);
> > 
> > It seems that this patch is mechanical replacement. If you check the
> > callers, the page_index is passed from an int that iterates over bits
> > set in an unsigned long (bitmap). The result won't overflow.
> 
> Not mechanical, but I clearly made mistakes.  Will you pick up the
> patches which actually fix bugs?

Yes, I just replied to the first patch, that does fix an overflow.
