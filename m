Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC53826A
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfFGBnu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 21:43:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46201 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFGBnu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 21:43:50 -0400
Received: by mail-lf1-f67.google.com with SMTP id l26so333490lfh.13
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 18:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mZgTH88YDUMST/OXgom8QD/I3d3Gv0GX3WXCGKiYlg4=;
        b=KWPKSVehICSi1Womq4qW9+047ORVvQkhx/icf8/i6hBuVDDs++Kw3QJQs0LZID445W
         8x2PzHMZzl69IWxaOSvVehRoSNWKO9hDVLnYwTBy3IRkka2jgE/uZpaHInHsCNfg975N
         3+8vJ2cyJbrNdVSC5RRHCdlrpPghUR0e3VixFr4Tsu1S6bi+ZHpyxSxUIIu2qjcf1VYq
         jRJMnnj4J2ZgU1CDe6ce2m9rDGbxSlfncFtuodak6x8QQKRqkvrhN/voCDbO0vMiRsvV
         TzOirFFZ2ZeDtEh7HyWOClLfwarDrQ01VJUD0+/7rVQT3bRxkDdVhIDgqfp7VO2T2D+2
         7puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mZgTH88YDUMST/OXgom8QD/I3d3Gv0GX3WXCGKiYlg4=;
        b=lhvUOBE28fi8Z5eU47BGVvZBkmaMAVJpDkSDCF7GFgRs2vIcya2j5pr7H1Cb6Mrti+
         g5ptiQvQ48eu1qLr+8xY0U62M9ZTES6GgB7fG1Ebx2DiCfQWqVf78vOWIUfr6p1KpKLE
         ASn+kBfhypFsSdKWDp9qBmgTaQ0vlDER6ILETcCDGi3wescbHNeEv2oXIryN9cd5J8zX
         fuuahqK+90JSBobn2meQKVBUakhLTSys4QgSU1RcdaCOsTm0c+vla3Gd37rHCesn/klp
         5XaHdtcl3oHVdIvN6INC1MAYXT2hHDHeBNWNOd1z1DTguCdOgp49wC+rxcHmKCRzA1iO
         8Raw==
X-Gm-Message-State: APjAAAXROoLUvRR8TSyLZD7z5oPd9sYL7JbVwFBOWMspCYMTI9ZZbhq2
        hjXGOKd47GflyNm4jqPkQPXmz/a2OZlOvrcBAtmMm9WrVNA=
X-Google-Smtp-Source: APXvYqzpdg+dilOyU4LZksuSI90swhogr1EqR0jSr9PRycVMhAVX8TTrtmdHOwfO5n6dOaYKXhHId3c8enbmCq+cQY4=
X-Received: by 2002:a19:2247:: with SMTP id i68mr24656362lfi.174.1559871828120;
 Thu, 06 Jun 2019 18:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190604135119.8109-1-xxhdx1985126@gmail.com> <52aacd32597d3f66b900618d7dddd52b6bd933c7.camel@kernel.org>
 <20190606191545.GR374014@devbig004.ftw2.facebook.com>
In-Reply-To: <20190606191545.GR374014@devbig004.ftw2.facebook.com>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Fri, 7 Jun 2019 09:43:36 +0800
Message-ID: <CAJACTudbNaLZ8+gMcOSgs5xo3q_JiDxh84ooVuqcue9YbmPgrg@mail.gmail.com>
Subject: Re: [PATCH 0/2] control cephfs generated io with the help of cgroup
 io controller
To:     Tejun Heo <tj@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Xuehan Xu <xxhdx1985126@163.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 7 Jun 2019 at 03:15, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Jun 06, 2019 at 03:12:10PM -0400, Jeff Layton wrote:
> > (cc'ing Tejun)
>
> Thanks for the cc.  I'd really appreciate if you guys keep me in the
> loop.
>
> --
> tejun

Hi, tejun.

I'm really sorry that I didn't send these modifications to you. I
thought it would be impolite and may piss you off if I insist on
submitting the patches that you had pushed back. But, on the other
hand, we really think that a some kind of simple io throttling
mechanism, although may not work very well, may provide some basic
functionality to restrain the io pressure that comes from a single
client. Actually, that's the case in our production CephFS clusters,
in which we have only one active metadata node and there are times
that some minor crazy clients send out large amounts of
getattr/lookup/open ops to the metadata node and make other clients'
metadata ops' response time increases significantly. We think if we
can limit the ops issued by a single client, the total ops sent out by
some minor clients would be also limited to a relatively low level.
This is indeed far from sufficient to provide perfect io QoS service,
but it could help before a full-functioning io QoS service is in
position. So I thought maybe I can first discuss this with CephFS
guys, and if they don't agree, I will back down. Again, I'm really
sorry that I didn't add you to this discussion, please forgive me:-)

Hi, jeff

According to our observation, the number of crazy clients was always
10 to 15, and normal clients' metadata ops issuing rate is below 80
per second. And according to our stress test to the MDS, it can
provide 11000 getattrs and 3000 file/dir creation per second. So we
thought we could suggest the users to set their  metadata iops to 100,
which should be sufficient for their work and won't cause severe
damage to the whole system when it comes too crazy. This approach is
indeed primitive, but since a full-scale io QoS service is not
available and relatively hard to implement, we thought this should
provide some help:-)

Thanks for you guys' help:-)
