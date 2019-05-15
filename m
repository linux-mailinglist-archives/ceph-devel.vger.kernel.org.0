Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E021F2FD
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 14:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfEOMJn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 08:09:43 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:32964 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbfEOMJm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 08:09:42 -0400
Received: by mail-pf1-f171.google.com with SMTP id z28so1288689pfk.0
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 05:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ItHAljgJbnq3OKSEeQTXOpIHHJFrdbouHaGq041yb4c=;
        b=jFLKWgBBeh2UIM1vQqQZnhTIDM8AKqS5UyEzvzLdHMF7UV4phGFSlKQ20mZrgwYoeM
         Qn8zuSU4YvLZ8MfovICAoDJUCgQFIhg+Ls3trEG6wP76j+Gq5RzOptO//WSYn3FopNf6
         6NYrGlR8Vq2yA5b69u1m9wcXeCQ+/iX1OuFZREtWv7JZyurO+85VDcs27R2ULUEozd7S
         aYg4zbC6+ZynYmkImRegdTZNph8AKb3SebesWBxskk1B21h3HV9A+o/MuGBLrgO4+bCe
         NSobchClGbSZMxggXgucdMGKHtFl9AroU83MqkgTzf8FzjW8d0sGXK8LpD9Dd97Zghgc
         T8pg==
X-Gm-Message-State: APjAAAWFfw+b5p1CpP1GN61wJddTQrhvXuLcJ0ZRS8aBH2EZQrfV2Vkv
        x1/+Ln50HVPMenhFGnYLBj6PwFz3o9cMW7HuQS8fFxYMjLo=
X-Google-Smtp-Source: APXvYqyd8MPROzYnEfPxf2Fe4ugD+ONo47Ti2ghpKmbOs76MdClRjH3GofzTo0f71mglmUMLdbH9vEjAX9VCghFK510=
X-Received: by 2002:a65:6656:: with SMTP id z22mr43503346pgv.333.1557922181109;
 Wed, 15 May 2019 05:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
 <CAMMFjmH28geRKWpveQY3aWQCBp=_pFjOb_5YNchS_-bLxh_g+Q@mail.gmail.com>
In-Reply-To: <CAMMFjmH28geRKWpveQY3aWQCBp=_pFjOb_5YNchS_-bLxh_g+Q@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Wed, 15 May 2019 05:09:29 -0700
Message-ID: <CAMMFjmGkWVY4ozHUYJo3EWX0OBAGQOrBAJZRYkOnG60V5E5KcA@mail.gmail.com>
Subject: Re: PRs for next mimic release
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Nathan Cutler <ncutler@suse.cz>,
        Abhishek Lekshmanan <abhishek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Merged last 3 PRs for rgw requested to be included and unless I hear
otherwise will start QE soon.

Finial SHA1 d035c2f7907323ffb777cd22ea74f9f5e78d808c

Thx
YuriW
