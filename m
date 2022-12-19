Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03E650AEA
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Dec 2022 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiLSLqQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Dec 2022 06:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiLSLqO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Dec 2022 06:46:14 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2521221
        for <ceph-devel@vger.kernel.org>; Mon, 19 Dec 2022 03:46:12 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EB1AF60027FC1;
        Mon, 19 Dec 2022 12:46:09 +0100 (CET)
Message-ID: <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de>
Date:   Mon, 19 Dec 2022 12:46:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: PROBLEM: CephFS write performance drops by 90%
Content-Language: en-US
To:     Xiubo Li <xiubli@redhat.com>,
        Marco Roose <marco.roose@mpinat.mpg.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
 <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
 <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear Xiubo,


Am 19.12.22 um 11:48 schrieb Roose, Marco:

> my colleague Paul (in CC) tried to revert the commit, but it was'nt
> possible.

> -----Original Message-----
> From: Xiubo Li <xiubli@redhat.com>
> Sent: 19 December 2022 01:16
> To: Roose, Marco <marco.roose@mpinat.mpg.de>; Ilya Dryomov
> <idryomov@gmail.com>
> Cc: Ceph Development <ceph-devel@vger.kernel.org>
> Subject: Re: PROBLEM: CephFS write performance drops by 90%

[…]

> Since you are here, could you try to revert this commit and have a try ?
> 
> Let's see whether is this commit causing it. I will take a look later this
> week.

Unfortunately, reverting the commit is not easily possible, as the code 
was changed afterward too. It’d be great if you provided a git branch 
with the commit reverted.

Marco, if you have time, it’d be great if you tested Liunx 5.6-rc7 and 
5.6, where the commit entered Linus’ master branch.


Kind regards,

Paul
