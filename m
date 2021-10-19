Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B22043424C
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 01:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhJSXve (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 19:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhJSXvc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Oct 2021 19:51:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E29C06174E
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 16:49:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r4so12379002edi.5
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 16:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpDry/4vppRTdkM/5uTPl5dyLlGXb8npQEXSH8SC3n8=;
        b=o2GB6bGy73ynHmJi3Gg4hEYN2Dm0AvQJTbKeajulhWdOW5eNjC2JDiAycN4FAXuZVu
         QOlxhQTFFF3dwFNUX78Dq+3+GI0T8ycd7lmeW4LD/RLJdg1IG204YBu1stQ0sSE9O9aZ
         slfxNIO+pajQUUZ9zBFJG7CWumjrgZX95S90ugGG52KhNUrFHcQQ3u04lB7OjMz77eNp
         9x/qAM0TbHBx8bT7bMwuDm1gsvioW83tOrqFUzRWjJC3k1fEh44py+hqvv7OcrHUAbQN
         /reiwOMaaXdhdTnSDny8pD9reCSgGZKgAes9sIfzb2yFipwOPvP1YYN29F9+X/95xkYK
         CbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpDry/4vppRTdkM/5uTPl5dyLlGXb8npQEXSH8SC3n8=;
        b=nBMhMnEdIs7xN1RHIyMtolhkcADm4p3OzOe+27FEY5bR8u635NDDacvSN39oy3qeDi
         lSzBEgArg4t7klrpTWEksZc7+2dKIET7GYk/N3o+IPl/Zi+aPxOUj13FVcheaZuXZ/ba
         Q+VuR4XtZCa7+7EtF5TkYK4nZzKnFbqxKYNyA99cKHrkr1ffyb8E/QKDZnZEbb35/dJ9
         3Mz6GWb7EeBtt4wMlWKG4LBNdw6oNctJC5XgGTxBYh2PjasE90jJwNiFnA8lfeO6lZlt
         bQ0x4xivoiknTefsEkIMiMrpWBcMYs16fhtUPSWNHDFi7jAAd+XjiYwmPxr51DnQ4O/k
         LcGA==
X-Gm-Message-State: AOAM53375s+F7V44KxIcfKDtSLfikCQ5LueNfDdEcDTliVg86uTQDEpH
        huB0SwWgT67o6zlh2tpuF7mdWR3unZL6XbiOZhbl
X-Google-Smtp-Source: ABdhPJwbdYmhpXUTSsSR/XIYzH5m1pFEBMpnAv4GFXli0FULWWj6vmRgoYkSQoTjr2PW6RgpGUKOegfQ46qGkGqGzcA=
X-Received: by 2002:a17:907:629b:: with SMTP id nd27mr40164593ejc.24.1634687357008;
 Tue, 19 Oct 2021 16:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <YWWMO/ZDrvDZ5X4c@redhat.com> <YW1qJKLHYHWia2Nd@redhat.com> <3bd86fa3-b3b0-754f-25a5-5e4f723babe4@namei.org>
In-Reply-To: <3bd86fa3-b3b0-754f-25a5-5e4f723babe4@namei.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 19 Oct 2021 19:49:06 -0400
Message-ID: <CAHC9VhRZyGYsFziXMfJQ=1OcLO52TGmAGMi5RaA3FXRgREsSeQ@mail.gmail.com>
Subject: Re: [PATCH v2] security: Return xattr name from security_dentry_init_security()
To:     James Morris <jmorris@namei.org>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org,
        virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Dan Walsh <dwalsh@redhat.com>, jlayton@kernel.org,
        idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, bfields@fieldses.org,
        chuck.lever@oracle.com, anna.schumaker@netapp.com,
        trond.myklebust@hammerspace.com,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        casey@schaufler-ca.com, Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 19, 2021 at 5:02 PM James Morris <jmorris@namei.org> wrote:
>
> On Mon, 18 Oct 2021, Vivek Goyal wrote:
>
> > Hi James,
> >
> > I am assuming this patch will need to be routed through security tree.
> > Can you please consider it for inclusion.
>
> I'm happy for this to go via Paul's tree as it impacts SELinux and is
> fairly minor in scope.

I'll take a look tomorrow, I ended up spending most of my day today
chasing a 32-bit MIPS (!!) bug in libseccomp and now it's dinner time.

-- 
paul moore
www.paul-moore.com
