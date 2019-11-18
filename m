Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE612100642
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKRNMm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfKRNMm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 08:12:42 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F9C52071C;
        Mon, 18 Nov 2019 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574082761;
        bh=WMe0I3EG4ps7xAe3DkVvXD3fbqLLGFm0wowZjHciiQY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=z/L6foljQByrauIjOI06JjV8sgoV4yE3qF1V9DNieqEgkqN2ps64CE18YqzmwQv4i
         z2mVqVGNQpcTGHmH5ckJdaAtPTEQeIuWWKWG31lyolu1lbZ5YeSb180Ee89ofrta0r
         xBOPuP6/qICXsw0aMUdRPj+r3qCI7L7Hq2m9bZ4w=
Message-ID: <3dc2df0ba5776fb0f7aaac3a099a938823ed0ebf.camel@kernel.org>
Subject: Re: [RFC PATCH v3] ceph: add new obj copy OSD Op
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 18 Nov 2019 08:12:39 -0500
In-Reply-To: <20191118120935.7013-1-lhenriques@suse.com>
References: <20191118120935.7013-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-11-18 at 12:09 +0000, Luis Henriques wrote:
> Hi,
> 
> Before going ahead with a pull-request for ceph I would like to make sure
> we're all on the same page regarding the final fix for this problem.
> Thus, following this email, I'm sending 2 patches: one for ceph OSDs and
> the another for the kernel client.
> 
> * osd: add new 'copy-from-notrunc' operation
>   This patch shall be applied to ceph master after reverting commit
>   ba152435fd85 ("osd: add flag to prevent truncate_seq copy in copy-from
>   operation").  It adds a new operation that will be exactly the same as
>   the original 'copy-from' operation, but with the extra 2 parameters
>   (truncate_{seq,size})
> 
> * ceph: switch copy_file_range to 'copy-from-notrunc' operation
>   This will make the kernel client use the new OSD op in
>   copy_file_range.  One extra thing that could probably be added is
>   changing the mount options to NOCOPYFROM if the first call to
>   ceph_osdc_copy_from() fails.
> 

I probably wouldn't change the mount options to be different from what
was initially specified. How about just disable copy_file_range
internally for that superblock, and then pr_notice a message that says
that copy_file_range is being autodisabled. If they mount with '-o
nocopyfrom' that will make the warning go away.

> Does this look good, or did I missed something from the previous
> discussion?
> 
> (One advantage of this approach: the OSD patch can be easily backported!)
> 

Yep, I think this looks like a _much_ simpler approach to the problem.
-- 
Jeff Layton <jlayton@kernel.org>

