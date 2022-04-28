Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF69B512DD1
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344000AbiD1ILt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 04:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343868AbiD1IK6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 04:10:58 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12329633BB
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 01:07:37 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id n14so7160273lfu.13
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 01:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3ZjQZG2T09sX84KZoMmaZgnceJT8vxnozrBMwBfGNM=;
        b=gjBRtDH70b5jo6u2b6jgMARq3Xjk0ClteRYVgsuMp8BtED+/Z/vPm5ATwITAxImkoG
         BsE3HfMu9OH3CiguvPjuCC3FNd8i3PqppQqnksKquSntLwl6s7O3k3Ge26XgdpgnW7Z4
         qkTJl1jqfBPfbr0g9ILY3OXYt+I1kkESS8lit7avLeCSsy5yfkkJNhdw4dpRMmuc8JqS
         yq+zKzLMon0K0ae9qrZ7ndNC2IBJ8uyENtjkr5P8FbPSpgDaNvlHj5YOm75iakuz5nu0
         XLygSDMAsIFm+gNsGKeReiIAh9LZ2YXTHiCYLPlAVcPIms94BzLz7MaThii3nrSZrbxd
         J0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3ZjQZG2T09sX84KZoMmaZgnceJT8vxnozrBMwBfGNM=;
        b=vsdTIG50bZ6EU9CY9zMsSo3hC9KHfxzRRpW6heDnO1Ojb4DVXOYJMRofooOUrq3Zw0
         vWhff5ylj4O6m2gJJxYqhu3GDqntUcJ+6z+rddSJvb1UFpFL5fUdDMWvlomQTBgdMUmw
         aWDNgTHwe9vtoCleqWG2q7p5zhrS+4nji8FDEewZVP/oHkmzcTtVqpx044Y4FP8oIDcZ
         5ZBx3m//HFHIVvhH0JSBMNXA1jmMeTov7bxsdB+6pCY080/mXs5uRZzpqfI/BfUU3OcG
         7ExIsSFAVHGDV6d3eERtsihJs+5M1aZCitS3dkGy7+tdxIz175mjYlcWyg0gN7teSMel
         Fygg==
X-Gm-Message-State: AOAM532yohrEnRdq2bB/BeC1ekmNzR9/08g0FX3v+N6fR5vxFQ85m8tN
        uPi/6+Le6qMyvDr5G6Dx1EWwQ/D8zuIsuPj9U5yWqQ==
X-Google-Smtp-Source: ABdhPJzGnYj50OoGGT/MGdQXvjVOVHLw2nhp6+XJqKPeN3Gww7x+4GV9YNC3NiaQRtmbnXOtwA+kqjFugNxiNe4OFf0=
X-Received: by 2002:a05:6512:3484:b0:472:13f9:4aee with SMTP id
 v4-20020a056512348400b0047213f94aeemr9831999lfr.288.1651133255155; Thu, 28
 Apr 2022 01:07:35 -0700 (PDT)
MIME-Version: 1.0
References: <1650971490-4532-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <Ymn05eNgOnaYy36R@zeniv-ca.linux.org.uk> <Ymn4xPXXWe4LFhPZ@zeniv-ca.linux.org.uk>
 <626A08DA.3060802@fujitsu.com> <YmoAp+yWBpH5T8rt@zeniv-ca.linux.org.uk> <YmoGHrNVtfXsl6vM@zeniv-ca.linux.org.uk>
In-Reply-To: <YmoGHrNVtfXsl6vM@zeniv-ca.linux.org.uk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 28 Apr 2022 10:06:58 +0200
Message-ID: <CAG48ez0LAF1NX+SBNNpzNrLMyccZEAS1GLrzYdhn_NoDFr=DLg@mail.gmail.com>
Subject: Re: [PATCH v8 1/4] fs: add mode_strip_sgid() helper
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 28, 2022 at 5:12 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Apr 28, 2022 at 02:49:11AM +0000, Al Viro wrote:
> > Let's try to separate the issues here.  Jann, could you explain what makes
> > empty sgid files dangerous?
>
> Found the original thread in old mailbox, and the method of avoiding the
> SGID removal on modification is usable.  Which answers the question above...

As context for everyone on the thread who isn't on security@, you can see a
public copy of the bug report here:
https://bugs.chromium.org/p/project-zero/issues/detail?id=1611
and also here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1779923

And the kernel patch in question is this one:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0fa3ecd87848c9c93c2c828ef4c3a8ca36ce46c7
