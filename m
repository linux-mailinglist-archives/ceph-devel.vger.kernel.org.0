Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D865D6189DD
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Nov 2022 21:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiKCUr0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Nov 2022 16:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiKCUrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Nov 2022 16:47:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DF820BE2
        for <ceph-devel@vger.kernel.org>; Thu,  3 Nov 2022 13:47:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so2949684pji.0
        for <ceph-devel@vger.kernel.org>; Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MxS/4UcS9QV06TA42jz+n7cPJ0B1Da1lpvr3ubjc6GY=;
        b=cuP5UtrVPLmPkgDyIU7nXUWip6wPNwEQX83eaiYzuSaa/NwaBOHxdiCCYvHyd3mrWb
         UX4IYw78zXIF0mMu0R7qDreIqrr7PvviOTacDCidW9f3UUssGYk9RosDNLvY+hm88Tz8
         hEooCKFouHczA6F3wBjXPLYrpYIszUEwnYnlDxkOvhuNi8oE//fz5w1SOEhhUUoWt77E
         pAHn5L/ZZzWw3HkpcasZr6hnf6O/XMcGhjxvLwJ33vohngsJ1KBKVvIfn+XAYIa1YRVX
         Vkpw4CNDgLSlpQfjW7+15/HKqs/xOt8+2WdHOo1jGBPReCKhIlOzYbvvyYROh/eydkAD
         rc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxS/4UcS9QV06TA42jz+n7cPJ0B1Da1lpvr3ubjc6GY=;
        b=TimaDqPAXGrRh9M6U8IjTM08W775cr0CUs/a+CFMADIX15QL8cUB3dWou0nuFaqO4L
         Voeb127Pps45lJAwIPzfNHpcNQfCQ4NKYaBSGZdmwpDAMa2exW9rBfEhQiLhoHyhOKr1
         KFvyhlJQOX+IaJjirVGZN15fCENXcEWkWZvx+FtSAIPglNwpn3c3uv6eVA5Lhsk3I51L
         jdin1FdElh85AYZ15byIZz43q53taCmw5RnImbDQ8lsjF66A4I3RV9n4RfoKyGPjncD8
         rMIdrATln5qFhYyhUQRXb98GnpHHRGQz1IQdNsCUttyDgFdB3s3smeNa5MV1iaU3EFrM
         H8kw==
X-Gm-Message-State: ACrzQf058zRi0ZCOjzr6TMH2R/lL6M9n4RB9PPt75QOObLP5MCUBbYtd
        58Q4+UAef/l55lhAhJhSGtS1hg==
X-Google-Smtp-Source: AMsMyM5GUtVQUrVsmSVgFmsiPB/ae+Y5AFUcecj0KBZFMpN2UeC1Le+3w3RaW8dan20LGNVVX2XxhA==
X-Received: by 2002:a17:90a:5781:b0:20a:9962:bb4a with SMTP id g1-20020a17090a578100b0020a9962bb4amr49118773pji.185.1667508442530;
        Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b00561b455267fsm1205656pfr.27.2022.11.03.13.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqh7P-009uXX-4a; Fri, 04 Nov 2022 07:47:19 +1100
Date:   Fri, 4 Nov 2022 07:47:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Vishal Moola <vishal.moola@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, linux-nilfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 00/23] Convert to filemap_get_folios_tag()
Message-ID: <20221103204719.GY2703033@dread.disaster.area>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221103070807.GX2703033@dread.disaster.area>
 <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 03, 2022 at 09:38:48AM -0700, Vishal Moola wrote:
> On Thu, Nov 3, 2022 at 12:08 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Nov 02, 2022 at 09:10:08AM -0700, Vishal Moola (Oracle) wrote:
> > > This patch series replaces find_get_pages_range_tag() with
> > > filemap_get_folios_tag(). This also allows the removal of multiple
> > > calls to compound_head() throughout.
> > > It also makes a good chunk of the straightforward conversions to folios,
> > > and takes the opportunity to introduce a function that grabs a folio
> > > from the pagecache.
> > >
> > > F2fs and Ceph have quite a lot of work to be done regarding folios, so
> > > for now those patches only have the changes necessary for the removal of
> > > find_get_pages_range_tag(), and only support folios of size 1 (which is
> > > all they use right now anyways).
> > >
> > > I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> > > beneficial. The page-writeback and filemap changes implicitly work. Testing
> > > and review of the other changes (afs, ceph, cifs, gfs2) would be appreciated.
> >
> > Same question as last time: have you tested this with multipage
> > folios enabled? If you haven't tested XFS, then I'm guessing the
> > answer is no, and you haven't fixed the bug I pointed out in
> > the write_cache_pages() implementation....
> >
> 
> I haven't tested the series with multipage folios or XFS.
> 
> I don't seem to have gotten your earlier comments, and I
> can't seem to find them on the mailing lists. Could you
> please send them again so I can take a look?

They are in the lore -fsdevel archive - no idea why you couldn't
find them....

https://lore.kernel.org/linux-fsdevel/20221018210152.GH2703033@dread.disaster.area/
https://lore.kernel.org/linux-fsdevel/20221018214544.GI2703033@dread.disaster.area/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
