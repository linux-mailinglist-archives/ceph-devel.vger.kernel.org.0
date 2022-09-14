Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DE35B832F
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Sep 2022 10:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiINIlV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Sep 2022 04:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiINIlU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Sep 2022 04:41:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBC21091
        for <ceph-devel@vger.kernel.org>; Wed, 14 Sep 2022 01:41:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z21so21143454edi.1
        for <ceph-devel@vger.kernel.org>; Wed, 14 Sep 2022 01:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VOPh03BbBjiwWyeGsmeh2KbHQL3vcPO6NV4aRfDpSWY=;
        b=HSGTKcWz68U7BzIUM/AsKsTcmMaM6FcIEHgx8R6ME3bM87gK5waBTd1yzMpfplpreO
         lmHy6QwkLrlDTdfaxDCEz96YehDhhaoYcFK8Drmlln5YLI64ysARRTLEqvpuuyBwiYdd
         ba8KgM+jmtfur65ekDMjuZsFtOjfXAiVbjmaRoNvQIiFPyXXG9SWyOrm4u+nJWUbdajJ
         iBQzd/VL7aNT3YMxet6shSv/Rs4hBfn8sXc7iWjbShKwEfdFyWk/3fPNOs4QJOSjDomS
         Vag62Z5ns1bnN8qnr93+5UC7XAEQDj7VAKMLxOWr1VPbXeK1RuvmaYkCjzBSvvY1GpdJ
         PwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VOPh03BbBjiwWyeGsmeh2KbHQL3vcPO6NV4aRfDpSWY=;
        b=5GYRlr5t5pYlgmBgqLCYOBbIuHbObn9VAgWGxG2B5Nusz5uzfsGF1Bz1IJjEb56VP0
         TpG3WahA1Bzt0QqoNyf2DWKG3ATBkfvhH9iFbeONHdVc+Mclh8rFoyzBZkqmCiknAGVx
         vm/LhtDAEw/deyjP/z3UFul/OukKEV/wW1Tsjb44aCBJs9ioAKYgZnWOJp0awzrBallh
         fRe85nhmQFspeaW+cjJxzsS2aEs4Hu/LCbAbXBhhxXjppFjMyuLngCznzSm4JgfcOwbO
         W/XxXXqvVmtiUzOvKANjW1FB3UFCuLrpuZ43zE6YRQaEbrjbDoJ7zfWs2R+uDy9RnxbK
         rKAQ==
X-Gm-Message-State: ACgBeo2AnH4gwdc3PFt3S/lL1WtmF7u8NFfiQ1owJHzVYID8cMpHLDaW
        rwmwaCExOLTvYF/jxSXBxFz8cl+2wXE1BE/bDyu4QgJKcpc=
X-Google-Smtp-Source: AA6agR6sSZ0d3YPt0WBrhyiY8fBuAE6K/GbScpG93j8IvJIznevwHbp4XYnR942ipS5D6BfwPtZAi0NLLTjjMnkXRRA=
X-Received: by 2002:a05:6402:f92:b0:44e:84e0:1d2a with SMTP id
 eh18-20020a0564020f9200b0044e84e01d2amr29582815edb.395.1663144877277; Wed, 14
 Sep 2022 01:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au> <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au>
In-Reply-To: <20220914034902.GA691415@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 14 Sep 2022 10:41:05 +0200
Message-ID: <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 14, 2022 at 5:49 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi Illya,
>
> On Tue, Sep 13, 2022 at 01:43:16PM +0200, Ilya Dryomov wrote:
> > On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >> What can make a "rbd unmap" fail, assuming the device is not mounted
> >> and not (obviously) open by any other processes?
> >>
> >> linux-5.15.58
> >> ceph-16.2.9
> >>
> >> I have multiple XFS on rbd filesystems, and often create rbd snapshots,
> >> map and read-only mount the snapshot, perform some work on the fs, then
> >> unmount and unmap. The unmap regularly (about 1 in 10 times) fails
> >> like:
> >>
> >> $ sudo rbd unmap /dev/rbd29
> >> rbd: sysfs write failed
> >> rbd: unmap failed: (16) Device or resource busy
> >>
> >> I've double checked the device is no longer mounted, and, using "lsof"
> >> etc., nothing has the device open.
> >
> > One thing that "lsof" is oblivious to is multipath, see
> > https://tracker.ceph.com/issues/12763.
>
> The server is not using multipath - e.g. there's no multipathd, and:
>
> $ find /dev/mapper/ -name '*mpath*'
>
> ...finds nothing.
>
> >> I've found that waiting "a while", e.g. 5-30 minutes, will usually
> >> allow the "busy" device to be unmapped without the -f flag.
> >
> > "Device or resource busy" error from "rbd unmap" clearly indicates
> > that the block device is still open by something.  In this case -- you
> > are mounting a block-level snapshot of an XFS filesystem whose "HEAD"
> > is already mounted -- perhaps it could be some background XFS worker
> > thread?  I'm not sure if "nouuid" mount option solves all issues there.
>
> Good suggestion, I should have considered that first. I've now tried it
> without the mount at all, i.e. with no XFS or other filesystem:
>
> ------------------------------------------------------------------------------
> #!/bin/bash
> set -e
> rbdname=pool/name
> for ((i=0; ++i<=50; )); do
>    dev=$(rbd map "${rbdname}")
>    ts "${i}: ${dev}"
>    dd if="${dev}" of=/dev/null bs=1G count=1
>    for ((j=0; ++j; )); do
>      rbd unmap "${dev}" && break
>      sleep 1m
>    done
>    (( j > 1 )) && echo "$j minutes to unmap"
> done
> ------------------------------------------------------------------------------
>
> This failed at about the same rate, i.e. around 1 in 10. This time it only
> took 2 minutes each time to successfully unmap after the initial unmap
> failed - I'm not sure if this is due to the test change (no mount), or
> related to how busy the machine is otherwise.

I would suggest repeating this test with "sleep 1s" to get a better
idea of how long it really takes.

>
> The upshot is, it definitely looks like there's something related to the
> underlying rbd that's preventing the unmap.

I don't think so.  To confirm, now that there is no filesystem in the
mix, replace "rbd unmap" with "rbd unmap -o force".  If that fixes the
issue, RBD is very unlikely to have anything to do with it because all
"force" does is it overrides the "is this device still open" check
at the very top of "rbd unmap" handler in the kernel.

systemd-udevd may open block devices behind your back.  "rbd unmap"
command actually does a retry internally to work around that:

  /*
   * On final device close(), kernel sends a block change event, in
   * response to which udev apparently runs blkid on the device.  This
   * makes unmap fail with EBUSY, if issued right after final close().
   * Try to circumvent this with a retry before turning to udev.
   */
  for (int tries = 0; ; tries++) {
    int sysfs_r = sysfs_write_rbd_remove(buf);
    if (sysfs_r == -EBUSY && tries < 2) {
      if (!tries) {
        usleep(250 * 1000);
      } else if (!(flags & KRBD_CTX_F_NOUDEV)) {
        /*
         * libudev does not provide the "wait until the queue is empty"
         * API or the sufficient amount of primitives to build it from.
         */
        std::string err = run_cmd("udevadm", "settle", "--timeout", "10",
                                  (char *)NULL);
        if (!err.empty())
          std::cerr << "rbd: " << err << std::endl;
      }

Perhaps it is hitting "udevadm settle" timeout on your system?
"strace -f" might be useful here.

Thanks,

                Ilya
