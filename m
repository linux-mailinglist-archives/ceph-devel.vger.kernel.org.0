Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4125BC621
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Sep 2022 12:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiISKOW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Sep 2022 06:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiISKOV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Sep 2022 06:14:21 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2444D1C107
        for <ceph-devel@vger.kernel.org>; Mon, 19 Sep 2022 03:14:20 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x94so23218832ede.11
        for <ceph-devel@vger.kernel.org>; Mon, 19 Sep 2022 03:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LRkW0Xa89jN9amf4dG8y9PePAvWxc8WrmCTAbKtwcwA=;
        b=lYcuW23fgYWe7gy8TZbasdzbHZkoMz/Waf5JRcWJuHkYo/5PowsSpw+AwW+pQPjmtV
         Zi6TgrP7iu+sj8d9LOOTaZjY+bp5fAo23PYLn7OgBaHeXswD1OwBLkIkFMbPu05C+Nyh
         V53AH23KfUtOTpBe5Hu6NOxpfyamKiFYHK8OffVzEQBJI4F3BtFerXM3bvRSPCREq+hf
         3obnnLQ8hcZpns/TQUGvqruEX5MyrMVWe8HSQ6/LXRA8hTTIyhoZqMRm251nAt+7wHPZ
         RGiCC0rd2GHttgdP2Szyk+uhE2UwiabfNYnSe13As5NoYxoBkf3TDgB/2ni2S6GKE5mn
         u6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LRkW0Xa89jN9amf4dG8y9PePAvWxc8WrmCTAbKtwcwA=;
        b=hQfNfTrxqars6JGgskcpkwx2uGdYS5UNh8bUfZ4eGZOzQEXUSK3f1O+Bby/XkS9aN6
         bA3aQYKmgnIAr27XnQs5yu3pfg82d6iYChhmvzXA8rPSBKFfyune9MC9fla2LzVzmRWP
         6tFsZb8fAxXDbx69KZjiN+KdHwfswhG6NHpzZnDBIIYgzQiZekoBiGoRfZ+b+dgyZsk+
         Ht4OHKKLAr9c8Hvw9X9bbH6ZiUAd4zVGFp71zCDh8rOnoj7CC8lze8xIzfKhe8SBS4+8
         dixafLF3GWP9xzN2xm7WC8Ik/rd/yHl1YddSdM4aYXj/FU0zBXalqzb0/axazxyf8+JF
         EUoQ==
X-Gm-Message-State: ACrzQf32E5U4S/o8wb1t+/mVWMNgJ25ZqpMywRv3fYzfTPVF4Henk4hF
        mRd57JU/Q+K8bTFborLvAVKYYtKfRtK3jqYrCLL3HgR+2k8=
X-Google-Smtp-Source: AMsMyM4MEKybtLIbH6S9P/Sla1CPxz0wioO/292YzG/JYaHH8B1g36HzXu+DVR9wSbrPXamKDLmrnhYypn2PU0ExPUc=
X-Received: by 2002:aa7:d054:0:b0:450:f6b9:bc2e with SMTP id
 n20-20020aa7d054000000b00450f6b9bc2emr14700306edo.413.1663582458546; Mon, 19
 Sep 2022 03:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au> <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au> <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au> <20220919074321.GA1363634@onthe.net.au>
In-Reply-To: <20220919074321.GA1363634@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Sep 2022 12:14:06 +0200
Message-ID: <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 19, 2022 at 9:43 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> On Thu, Sep 15, 2022 at 06:29:20PM +1000, Chris Dunlop wrote:
> > On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >> What can make a "rbd unmap" fail, assuming the device is not mounted
> >> and not (obviously) open by any other processes?
> >>
> >> linux-5.15.58
> >> ceph-16.2.9
> >>
> >> I have multiple XFS on rbd filesystems, and often create rbd
> >> snapshots, map and read-only mount the snapshot, perform some work on
> >> the fs, then unmount and unmap. The unmap regularly (about 1 in 10
> >> times) fails like:
> >>
> >> $ sudo rbd unmap /dev/rbd29
> >> rbd: sysfs write failed
> >> rbd: unmap failed: (16) Device or resource busy
> >
> > tl;dr problem solved: there WAS a process holding the rbd device open.
>
> Sigh. It turns out the problem is NOT solved.
>
> I've stopped 'pvs' from scanning the rbd devices. This was sufficient to
> allow my minimal test script to work without unmap failures, but my full
> production process is still suffering from the unmap failures.
>
> I now have 51 rbd devices which I haven't been able to unmap for the
> last three days (in contrast to my earlier statement where I said I'd
> always been able to unmap eventually, generally after 30 minutes or so).
> That's out of maybe 80-90 mapped rbds over that time.
>
> I've no idea why the unmap failures are so common this time, and why,
> this time, I haven't been able to unmap them in 3 days.
>
> I had been trying an unmap of one specific rbd (randomly selected) every
> second for 3 hours whilst simultaneously, in a tight loop, looking for
> any other processes that have the device open. The unmaps continued to
> fail and I haven't caught any other process with the device open.
>
> I also tried a back-off strategy by linearly increasing a sleep between
> unmap attempts.  By the time the sleep was up to 4 hours I have up, with
> unmaps of that device still failing. Unmap attempts at random times
> since then on that particular device and all the other of the 51
> un-unmappable device continue to fail.
>
> I'm sure I can unmap the devices using '--force' but at this point I'd
> rather try to work out WHY the unmap is failing: it seems to be pointing
> to /something/ going wrong, somewhere. Given no user processes can be
> seen to have the device open, it seems that "something" might be in the
> kernel somewhere.
>
> I'm trying to put together a test using a cut down version of the
> production process to see if I can make the unmap failures happen a
> little more repeatably.
>
> I'm open to suggestions as to what I can look at.
>
> E.g. maybe there's some way of using ebpf or similar to look at the
> 'rbd_dev->open_count' in the live kernel?
>
> And/or maybe there's some way, again using ebpf or similar, to record
> sufficient info (e.g. a stack trace?) from rbd_open() and rbd_release()
> to try to identify something that's opening the device and not releasing
> it?

Hi Chris,

Attaching kprobes to rbd_open() and rbd_release() is probably the
fastest option.  I don't think you even need a stack trace, PID and
comm (process name) should do.  I would start with something like:

# bpftrace -e 'kprobe:rbd_open { printf("open pid %d comm %s\n", pid,
comm) } kprobe:rbd_release { printf("release pid %d comm %s\n", pid,
comm) }'

Fetching the actual rbd_dev->open_count value is more involved but
also doable.

Thanks,

                Ilya
