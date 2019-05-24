Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34E929712
	for <lists+ceph-devel@lfdr.de>; Fri, 24 May 2019 13:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390935AbfEXLWd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 May 2019 07:22:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36133 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390701AbfEXLWc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 May 2019 07:22:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id y10so6868231lfl.3
        for <ceph-devel@vger.kernel.org>; Fri, 24 May 2019 04:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtLEi7IeQpCb1ppGMbFbJxKfy5N0KF40tRl9GVfjIww=;
        b=TbGbyujM4BZkanQt4m+W4BlpKcBDQgmrpP7KyJafBNAB7nWDoPHb7bd3WVo5A+vPQ7
         nVam+Qk/EXxAfmX0GIblhG+AdxZGguv3jwsKhnYGVjwQy2AsY9KRwzAcVMAPGPNsxe1f
         ORC0XVDAO/LkenngpyX2fmja53Be7K27/sdS0ji7KqK4BMWBL48rKdEMovHEjToAC984
         pye6ZZCn2Lye2VkiqzBz5fs7m9q1G5bwKf9PtQeLtoXuS4XIXF7j+y7vLQzE40FGrd/N
         4yo4CxOFhWFAipy6i7RPPA8mn58AevRve4kSyCcIS04ngn5cSlzLrm2oSxZLMXpnCtCc
         AJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtLEi7IeQpCb1ppGMbFbJxKfy5N0KF40tRl9GVfjIww=;
        b=TH4ees/6Z2KIpqlT1wDCYq9fGFAFON5UB4lDlCsmrP2tLbBKolFcSAXacVnw/kulaR
         uBCni0xqI6wEjJQ2DmrpDWmr02yBwbqApKThCqjOsOKWfoQScBPkq+jSn9yXcXUxh6QC
         IsZfxctsb9/2XDdB1p7QPUJmbZ6f/v3FMR7YvSnLfQ6LZ2NBmplW7vW0Mo2XWe0yeNQB
         9DCamg3sdt4aleyEFOyDooRKnT2CkQ30q8bXSDl6fzjdWcjom6NxRmBIj8s5kZiz70tB
         +EmHS7eAdqeAdh+v6u9idZYwRfptmhZTAMzSe70YBw0rOPEOC/COXS8ri0IboDggsH6G
         0MJw==
X-Gm-Message-State: APjAAAVDdt9UpHUU0yx2eysYMs8GKYylvMlWp+6I/7XbVZPzZVM71E7/
        0iKcSrj3/hccbaQql142gFahNh/aAO2jrv596qA=
X-Google-Smtp-Source: APXvYqzPq6M4ebYEqRfYJ5CsVBdqRSDYzShkeiRWy51volM1+6Bf+XB7eUGLtzOcxS8wI1Hb9ykyEUSyeqFzDtNmhPc=
X-Received: by 2002:ac2:5a1b:: with SMTP id q27mr45731025lfn.63.1558696951432;
 Fri, 24 May 2019 04:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190430120534.5231-1-xxhdx1985126@gmail.com> <20190430120534.5231-2-xxhdx1985126@gmail.com>
 <CAOi1vP8aBw8-GO1Y8J4CNLZtZkxTrvg4JCGL1Qg8Gn_phQtSsw@mail.gmail.com>
In-Reply-To: <CAOi1vP8aBw8-GO1Y8J4CNLZtZkxTrvg4JCGL1Qg8Gn_phQtSsw@mail.gmail.com>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Fri, 24 May 2019 19:22:01 +0800
Message-ID: <CAJACTudmYCxBcHQ4UTC5OQ-eS6yU9AAO9nROLh5dxEjqAf77Sw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: use cephfs cgroup contoller to limit client ops
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>, Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> Looking at the previous patch, get_token_bucket_throttle() blocks
> waiting for the requested tokens to become available.  This is not
> going to work because ceph_osdc_start_request() is called from all
> sorts of places, including the messenger worker threads.
>
> ceph_osdc_start_request() should never fail.  Treat it as a void
> function -- the return value is ignored in new code and the signature
> will eventually be updated to *req -> void.
>
> Thanks,
>
>                 Ilya

Hi, llya, thanks for your review:-)

We've already run this code in one of our cluster. It does work.
ceph_osdc_start_request() will not fail, because we treat tb->max
being 0 as shutting down the controller, and made sure that, before
setting tb->max to non-zero value, token bucket timer work is already
started and tb->throughput is not zero too. So if tb->max is 0, the
controller is shut down, and ceph_osdc_start_request() would behave
just like the code without the controller; if tb->max is not 0, the
token will be filled when the token bucket timer fires, in which case
ceph_osdc_start_request() would not fail, either. Am i right?
Thanks:-)
