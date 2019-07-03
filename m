Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D194C5E30A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 13:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGCLpb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 07:45:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46018 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfGCLpb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 07:45:31 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so3618468ioc.12
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 04:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsI3YVkBnq50Eg+6Eb2390W0lZetLAVGVBhOPEciNfY=;
        b=Hg7O1TTIZ63D09YsO4GYd+qShAnYtbaRF/R2bkHLsmrx+VP57YYdwHXOuphOE9JbLO
         mbLJcrs+FlDm/IrH/A7kXVw9Bg0Ydwmz3Jk4F4xqLpMHTjibpaWXKIpc8NhwnaDPdZG3
         h5/kXJZgkoyU1FfQEdAMpC8VtXfd2pRHV1uZ+4coh7/l8mAeccMmZ1BFa+D09QAXJCGY
         LQq9wjp5WlngqL2LxxjyKLO7Fj73K6Tpqf1QfPnNBhX/I6WFtLCJ5lJ/t3wEGDqI4gXl
         AxP7eGWrQ/xSNcY4culgDThk2p75lU43cQAye7ZCJTSvSFvdwUmbfUAES7htuyYFExNL
         ihYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsI3YVkBnq50Eg+6Eb2390W0lZetLAVGVBhOPEciNfY=;
        b=I6eI4ArZRFdCb5pq8pdGJd+zQf2k2KwGCemtUNDByI/RJge97qBpHJKOBeBRRozDN5
         5o23iOzOBMBVnbEepGJgmMv785GYz7RW5i042xnbcJCREIhXHlu0Zl+NEscmci07b/am
         ekO0F8JkdKE9+Rj14NMHWqVivpAU0Jz3L0Smg8LsCsxv1apKh5mEKqRJZ0vnMftK/bIo
         np35t7WIakNb+7/BiL3dAezTdfD72Sb/5sjOqZo0YAR/7IWUddjYlmWphUhCQoJufCRQ
         Qqs3Q3BjOhrZQQMpR1m3b8DSF4cWGs7vWyq82N15i5Ae3RkVt1llRxLnE27aTExFlH1R
         Dx/w==
X-Gm-Message-State: APjAAAXs/Vx2JPMtkDb4CPuegdOqus9GfzeWv2NBwH+6Kop+8aRm5y2T
        Qi+TVQXjOQDhNoXC5YOVkm+7h/cbMQsWCuzUek5iIzp7
X-Google-Smtp-Source: APXvYqwnnoA8TbyvyW7uN4G63MUYqKWGhji3D4L7RC1oY3TQv/2bYunwQE1XfM9YvqLp2tSpO0CRxbjxYdSrN/6xajk=
X-Received: by 2002:a5d:9550:: with SMTP id a16mr17582878ios.106.1562154330362;
 Wed, 03 Jul 2019 04:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <5D199B5B.3060203@easystack.cn>
In-Reply-To: <5D199B5B.3060203@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 13:48:10 +0200
Message-ID: <CAOi1vP9kCWW34=4gKNssROb7UHmrB7vkL0MyjzcAX-EFavb5BA@mail.gmail.com>
Subject: Re: [PATCH 00/20] rbd: support for object-map and fast-diff
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 7:34 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Hi Ilya,
>
> On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> > Hello,
> >
> > This series adds support for object-map and fast-diff image features.
> > Patches 1 - 11 prepare object and image request state machines; patches
> > 12 - 14 fix most of the shortcomings in our exclusive lock code, making
> > it suitable for guarding the object map; patches 15 - 18 take care of
> > the prerequisites and finally patches 19 - 20 implement object-map and
> > fast-diff.
>
> Nice patchset. I did review and a testing for this patchset.

Hi Dongsheng,

Thank you!

>
> TEST:
>        with object-map enabled, I found a case failed:
> tasks/rbd_kernel.yaml.
> It failed to rollback test_img while test_img is mapped.

This is because with object map reads grab the lock:

  67 rbd resize testimg1 --size=40 --allow-shrink
  68 cat /sys/bus/rbd/devices/$DEV_ID1/size | grep 41943040
  69 cat /sys/bus/rbd/devices/$DEV_ID2/size | grep 76800000
  70
  71 sudo dd if=/dev/rbd/rbd/testimg1 of=/tmp/img1.small
  72 cp /tmp/img1 /tmp/img1.trunc
  73 truncate -s 41943040 /tmp/img1.trunc
  74 cmp /tmp/img1.trunc /tmp/img1.small
  75
  76 # rollback and check data again
  77 rbd snap rollback --snap=snap1 testimg1

Without object map the lock is freed by resize on line 67 and rollback
executes on an unlocked image.  With object map we re-grab the lock for
dd on line 71 and rollback executes on a locked image.

rollback isn't supposed to work on a locked image, so it's just an
accident that this test continued to work after exclusive lock was
introduced in 4.9.

Another test that will need to be fixed is krbd_exclusive_option.sh.
This one fails both with and without object-map feature because we no
longer block if the peer refuses to release the lock.

I'm on vacation and didn't get a chance to update the test suite yet.

                Ilya
