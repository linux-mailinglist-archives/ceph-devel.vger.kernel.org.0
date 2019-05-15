Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246F01F951
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 19:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEOR1T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 13:27:19 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:51473 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEOR1T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 13:27:19 -0400
Received: by mail-it1-f169.google.com with SMTP id s3so1459828itk.1
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2P0eWNd/Lusg32wW4AOoVCZo0RqcijixcGA/0dd5cYs=;
        b=KGaMb+dOPDLVJvuTEkYI0t7Th1wc/LfO3ZW4WBVp6krRsrhmzKVZm2wUywVm5mO/tX
         up3eUDY181pvAKKMKz0fBmwyZO459YzeJ7LKTHoIRPwr53EgFi6wziddk2I4OiwvkEl+
         Xphu5XFJKq6BITElA9BnofI6dJN5dFQm80wCGm93s5Lqp/wLY00501MX4DAPLxFctTl3
         W2jW2pM8xM6u++Mze+JMGqLjbuF60P5sRElLM+OtctBI8CLi0qnKI/gFLivWhbmhRLpb
         sZPIaR81VqXAYyNAEfmVh2AuPw3QiVB91WwNP1vM13t0br/y7T+KFoQKr48LV4Rtn1MF
         ks/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2P0eWNd/Lusg32wW4AOoVCZo0RqcijixcGA/0dd5cYs=;
        b=RunSV7GrPWu+B9RKX60bnV6PLPyIlITeRBDDOTO5zpHZpuJg709PFVN6VCcki5MOsO
         hfYrWl580pv24ULrgDbJYdm4+2OqRUE6HfX0uTyyCTliPSnMeF1fL3qmJO/xQUS0Hohd
         MtmHVrHGi0sfXE1Kdig9JbaOO4QDqV+VbqOYq+RnkAASi6JreAtKNdc3ykguhxZi+rNk
         T5F9prv6tA0RdpOqg+ZZv83fCCth4Dhta7Jc/4pGAyTqxrawE5kmvSwMFmaU9jmDP9/1
         tUQVxaRluynZZKJPppITZXcPHdvOEYWrmzGP1YjFcJkHBUYzZg1mun9h+AcJ16944BQp
         kQeQ==
X-Gm-Message-State: APjAAAW1JvoRZD0z+1pAFNVOrkesvEZ3t7Wl8B7ClHI5dBd08U2onnR4
        ZR/ljtIUBpnrhbpnvQbzq0aCdIk9WqMCbaZAzvQ=
X-Google-Smtp-Source: APXvYqwVvYnR8ssXwHBlp3tjGvsTMg5FMMpr0up+9PeiNWpIGlCeE/yzH+2bjUWoICbxo+etFffHX9jUksggy9Y+71M=
X-Received: by 2002:a24:cf41:: with SMTP id y62mr8921606itf.106.1557941238147;
 Wed, 15 May 2019 10:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
 <CAMMFjmH28geRKWpveQY3aWQCBp=_pFjOb_5YNchS_-bLxh_g+Q@mail.gmail.com>
 <CAMMFjmGkWVY4ozHUYJo3EWX0OBAGQOrBAJZRYkOnG60V5E5KcA@mail.gmail.com>
 <87woiruckt.fsf@suse.com> <CAMMFjmF6n4ApAmosJpgr1sYHji+sY-sXufWqQaoDY47Ns8REbg@mail.gmail.com>
In-Reply-To: <CAMMFjmF6n4ApAmosJpgr1sYHji+sY-sXufWqQaoDY47Ns8REbg@mail.gmail.com>
From:   Abhishek L <abhishek.lekshmanan@gmail.com>
Date:   Wed, 15 May 2019 19:27:06 +0200
Message-ID: <CAEw75dOEtqQVX6cw+faTtU6aP9sN906W2DU42NBo_6-QkPG9Zg@mail.gmail.com>
Subject: Re: PRs for next mimic release
To:     Yuri Weinstein <yweinste@redhat.com>
Cc:     Abhishek Lekshmanan <abhishek@suse.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Nathan Cutler <ncutler@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 15, 2019 at 6:42 PM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> One more was added https://github.com/ceph/ceph/pull/28096

This should be fine to go through to final QE as it is. No need to run
an additional suite for this PR
