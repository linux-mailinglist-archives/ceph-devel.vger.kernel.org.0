Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ADB2D278F
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 10:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgLHJ03 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 04:26:29 -0500
Received: from verein.lst.de ([213.95.11.211]:45451 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgLHJ03 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 04:26:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 588796736F; Tue,  8 Dec 2020 10:25:45 +0100 (CET)
Date:   Tue, 8 Dec 2020 10:25:45 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to
 all partitions
Message-ID: <20201208092545.GA13901@lst.de>
References: <20201207131918.2252553-1-hch@lst.de> <20201207131918.2252553-5-hch@lst.de> <yq1y2i8x42d.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1y2i8x42d.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 12:27:41AM -0500, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > The existing behavior is inconsistent in the sense that doing:
> >
> > permits writes. But:
> >
> > <something triggers revalidate>
> >
> > doesn't.
> >
> > And a subsequent:
> 
> Looks like the command line pieces got zapped from the commit
> description.

Yeah.  It seems like git commit just removed them after I pasted them,
weird.
