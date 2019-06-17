Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFE349165
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 22:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfFQUce (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 16:32:34 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46314 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFQUcd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jun 2019 16:32:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id x18so7058625qkn.13
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 13:32:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmV+UXGeT60PKgFBejriyaSKNVR0EBB6XtcJAC0zbr8=;
        b=gS9+XP9PPOM6/BERZ3chokpOeeC5lF9ylhkFH+3+Y/ZzeDdBlStr5YLM45jt9ZKEkA
         ix5H+kl1rS9VABzGEjd46mQVYhXVsqwuC0+tm0juxRqQMb8/8VFpY0As4emHo0EFr2mL
         rw22H2a3h0QzpgSpcDSUmLDmR8pPelRRx6wts4sf5TCAGLUJF8G/dTNH4Bdugjfa36lw
         HhxHdailbOaEJgAijfun3P3PMtIY+NwvgOrWOH5bwJ0DQThxbKXUotK98Ht3uaDkK2VM
         1r+bSBQONK5vJxAWZEMPK4eci9LrHTwC3pwX99A7tTigB0fOCEPhjDKmNwYYaO1/hffC
         7+pA==
X-Gm-Message-State: APjAAAV2qnXx43fW6r1/DpXxztWXvxKmsho6pVDaeuBRxDA1wFynHXk4
        +F2lp4r2S5OWcZXvZ4RYN/f/1JHQvKfXVRjnft6naA==
X-Google-Smtp-Source: APXvYqxW+H/FD2+Gu60jVEWWDUjv2a27gxzrYHfmB2ovbgbBONVxx7SJ7wsXRLAjlUNCLa01Zi/wPvKYL/cCT6WWc3c=
X-Received: by 2002:a37:a743:: with SMTP id q64mr89697091qke.236.1560803552790;
 Mon, 17 Jun 2019 13:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-9-zyan@redhat.com>
In-Reply-To: <20190617125529.6230-9-zyan@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 17 Jun 2019 13:32:06 -0700
Message-ID: <CA+2bHPZBy8pFkhvSRnjBzD4dosP2E-n_hNWHXJxQPDqch=+y0Q@mail.gmail.com>
Subject: Re: [PATCH 8/8] ceph: return -EIO if read/write against filp that
 lost file locks
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 5:56 AM Yan, Zheng <zyan@redhat.com> wrote:
>
> After mds evicts session, file locks get lost sliently. It's not safe to
> let programs continue to do read/write.

I think one issue with returning EIO on a file handle that did hold a
lock is that the application may be programmed to write to other files
assuming that lock is never lost, yes? In that case, it may not ever
write to the locked file in any case.

Again, I'd like to see SIGLOST sent to the application here. Are there
any objections to reviving whatever patchset was in flight to add
that? Or just writeup a new one?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
