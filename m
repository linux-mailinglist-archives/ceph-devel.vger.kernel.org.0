Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7842E349C3
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 16:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfFDOI1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 10:08:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45759 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDOI0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 10:08:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so1542539lje.12
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+jMW86T9HmUs5kPg9sTa1KBpkfSbbWMfZNtq8kQnbI=;
        b=IQOe6bmkMUp+e2QSrVJxWET0PYAOAbDEka8iAjIe88T/nb3DbpVoCoRYKwtEAyyHzW
         0F0C3kmntthfrlVSVUh35GqtcaZSuFAeUeDkX1AZsHJOdmeKvsQcCi+DTxGwo0gwiEL6
         miGiRTyGBaKVK7SbjTod3uPcBCOUpAHcqQB8wleFA3dmP2uLWJ0dMpus5BKshrwL915I
         udFamQ32Xk95A1JKRNF73vE+TKiFXv5/YyiuUyufLC+b0fY7tUAteo0FrLby+3B07e1l
         aOgC4/vZf9Y5s4UbDQVH2sbA4ARWfB/k61o17bE/ivywQXfYvPOLfqeJJR+QuyiW4ovg
         tKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+jMW86T9HmUs5kPg9sTa1KBpkfSbbWMfZNtq8kQnbI=;
        b=F7OzPIqSbcxv3evO/p9vrg6tw+tj80p6ozdsPp/Iur3CigVQtvh+3pJ6DZ8iSvl/L+
         X0Fk4gjcDfVkQHSIFQ994h/Xv1UlS+maFCtdjh1dLk6QgZdulDTkO2Bj15DM25w8don+
         M0mGXhdm1KFtfbgxX3SHWxFHFpEwHT+2aTJa7WGLZm6HXDrzt4kdOe0jTAlBK6mD/vWU
         r1IY0ysCGA7rK4HayrhNVz8J+iTdjRIm6ii6/1TJCjSluCFP1R6Xt1p1C0T8+w9QEN2N
         jhMvxHt1LsqwZ9Wj0cQLKMAWp9EPGiy0h8OQDOBzo0+jq9IDrbawijeWp75r8c9l9Otq
         w7Tw==
X-Gm-Message-State: APjAAAXk97NDZy3OReEkT5CD++MiaztiAr3Z62Xoz0taZvAfqTeCRjk1
        b2kAV1kr6R3lrpU91jgFkptE/1hukUQM6iaIHr0=
X-Google-Smtp-Source: APXvYqxtqLwwW232CdjPQNoG9L8fUuagwye8TKn9gRj+l8WwRVY6cTL9WLWjo00+OjVSyyz9UD9EiSoHiAfqQ7W8wxk=
X-Received: by 2002:a2e:2f12:: with SMTP id v18mr16659900ljv.196.1559657304155;
 Tue, 04 Jun 2019 07:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAJACTufz=iQUcPW75vxX0qM6xK7Sd8XuDHrdZrAt4B9uGJGvog@mail.gmail.com>
 <CAOi1vP_nucPE4h7OcfSCDEJqF7OQkj=T8qwAAPA_ZUva6+zxtA@mail.gmail.com>
In-Reply-To: <CAOi1vP_nucPE4h7OcfSCDEJqF7OQkj=T8qwAAPA_ZUva6+zxtA@mail.gmail.com>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Tue, 4 Jun 2019 22:08:12 +0800
Message-ID: <CAJACTue62GeLKPeg45hB4+n6_387bg_WXt49cy4UgzO4duApgA@mail.gmail.com>
Subject: Re: [PATCH 0/2] control cephfs generated io with the help of cgroup
 io controller
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> Hi Xuehan,
>
> AFAICT only this cover letter has made it to the mailing list.  It
> looks like you cut and pasted from the terminal instead of generating
> the patches with git-send-email.  Please resend with git-send-email to
> avoid malformed patches and mailing list issues.
>
> Thanks,
>
>                 Ilya

Hi, ilya

Sorry, our server cannot connect to google mail server the other day.
I've resent all the mails. Please take a look, thanks:-)
