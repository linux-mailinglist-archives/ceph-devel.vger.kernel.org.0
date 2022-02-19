Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3B74BC877
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Feb 2022 14:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiBSNBW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Feb 2022 08:01:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiBSNBW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 19 Feb 2022 08:01:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF11FFF7F
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5437B80019
        for <ceph-devel@vger.kernel.org>; Sat, 19 Feb 2022 13:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEEAC004E1;
        Sat, 19 Feb 2022 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645275660;
        bh=aF1CWGmSS7aUR/0R8C2xpEYZut8gfIeZxAhSS3JKBHw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MU6sY/Ei0LgTwQ/kNUv4Ix210mSqklJWIe1JhdGSF4Fo4ITQ3hz+C9iUU6tEFr66E
         NfxVBkPL3VBDjNvugmxIPYhIW+tKBX3VeHPDitWMximSOPk9r8ub1EPXK7l+8oHaJg
         bdIS3sa1xYKSrqIMF5zD39IaRaUU75k6do8GkUAv+Dfvt8yBTfSZY7T3XYW5bwDY5a
         RoLL78MwvZtNUKGusKDT7CvW9+OI6WP8JCuVvEvva831umhpv/qgnmyzc6Ls8oasu7
         lBOC+lEk8Wk17min9IB4YWovNy5DYopy17XoS9hQ96+XzMEhzJYxqlUQej5ExhZ41X
         ZtjzYM24Wth2w==
Message-ID: <69d3b31e3f249a74df89eade581270be8e101f7a.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: do not update snapshot context when there is
 no new snapshot
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>,
        =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
Date:   Sat, 19 Feb 2022 08:00:58 -0500
In-Reply-To: <2d694ae4-5e06-7729-3dd5-063b5ab76ffd@redhat.com>
References: <20220218024722.7952-1-xiubli@redhat.com>
         <877d9si0b1.fsf@brahms.olymp>
         <2d694ae4-5e06-7729-3dd5-063b5ab76ffd@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-02-19 at 10:35 +0800, Xiubo Li wrote:
> On 2/19/22 12:53 AM, Luís Henriques wrote:
> > Hi!
> > 
> > I'm seeing the BUG below when running a simple fsstress on an encrypted
> > directory.  Reverting this commit seems to make it go away, but I'm not
> > yet 100% sure this is the culprit (I just wanted to report it before going
> > offline for the weekend.)
> 
> BTW, were you using the 'testing' branch ? It seems Jeff has not 
> included the fscrypt patches yet in it.
> 
> 

I went ahead and rebased the wip-fscrypt branch onto the latest testing
branch yesterday, and again this morning. It should now be based on the
current testing branch (with your latest fixes).

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
