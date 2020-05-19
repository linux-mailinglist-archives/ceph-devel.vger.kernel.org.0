Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED7B1D99F1
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 16:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgESOgC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 10:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgESOgC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 10:36:02 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE48CC08C5C0
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 07:36:01 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id s10so14742000iog.7
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 07:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8rDOi/S2GzjXMz+VtVMpPlJ21BydV7dzfMKViio4thk=;
        b=aU8yBVLZS2R6x4FTDSXd3bUatwpaG+02Xvfq7cdVhSc7UkLmv7tLP1iuJQStTWnr6E
         whV3OoSlWddxz06m22RVS2AEHfTpf4sYnmNWGwEnX9vpvxYY6v2V6rN533eKmMHJ5XrL
         N2cEAUI32kxsH6ANkupqTyb7eGHkRHhllM6uW5mmNj950ijV2AT5JSN9oZ+wXOeuBnJH
         CNux8AdBIuZSDomb5vjNPiRVUehab4bojdOgsjb3ibWMxEt6zy5QvhOS66rKiO2UUdeV
         wTB/WbikjKk2la+vlMP85v2dh13A1yC7RBTCNdHH2kGWWyokXRVrpfB6q52T/Yrsxzi0
         n62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8rDOi/S2GzjXMz+VtVMpPlJ21BydV7dzfMKViio4thk=;
        b=I159E4sS4FV0UtF8pfEomhWFItZQAmQOFZJHZ7y2KlhmLh30cuOzn7qg4MXOsETYBJ
         egGXWmEBwl39pw5AAxxfMTnkBd1dyxo6iJa8MXtQJKagHbQu+4sHz1On+Oz5GBhOsIAh
         8ElaE7zT5xZiJ59L4M7Xz1Awofq6+t3nWYCoRVNYDr4sxT9uSklWIyOSSFhz+6KXHjvb
         KDtJjjGrNiLLvxhJcNrCOVjhiNyXYhPFJDXU9khJ6bHMNsGebguYCT+rNm8MNtu9v1Qk
         rGM4BD6N80iWMj7jDHIEdyCVTc8dpKv4LnffjfTPIpnPbGIhiqvMp7fgaIZimjRuMlLT
         x3Mg==
X-Gm-Message-State: AOAM532FhJuJk9fk1UbMzZZlc+2FB1fyRa25AJ7ewJObNbhmgDjqN1a9
        pyRwUaSUbjk1dXkXZ7HY3RTajMXE7nGC3j+JylU=
X-Google-Smtp-Source: ABdhPJxAJi3eFeXn11x9YrK8/VlQP+cSALwgwOJj9ncu/LCkJqixxYSoEulkWt78wL3JeXyP3mxaBjeaZmfjhY7b4vk=
X-Received: by 2002:a05:6638:12d4:: with SMTP id v20mr9141933jas.96.1589898960845;
 Tue, 19 May 2020 07:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz>
In-Reply-To: <6n.cjI5.4P7G519BQ1k.1Um{AC@seznam.cz>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 May 2020 16:36:05 +0200
Message-ID: <CAOi1vP9HvJd-Cdm4TnfEjNN-PooZCAPBwANpS88UfinkhJuUsg@mail.gmail.com>
Subject: Re: ceph kernel client orientation
To:     Michal.Plsek@seznam.cz
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 19, 2020 at 3:44 PM <Michal.Plsek@seznam.cz> wrote:
>
> Hello,
>
> I am trying to get to functions responsible for reading/writing to/openin=
g RBD blocks in ceph client kernel module (alternatives to librbd=E2=80=99s=
 rbd_read(), rbd_write() etc.). I presume it should be located somewhere ar=
ound drivers/block/, but until now I=E2=80=99ve been without luck. My idea =
is to edit these functions, rebuild the ceph kernel =E2=80=98rbd=E2=80=99 m=
odule and replace it. Since comments are pretty much missing everywhere, it=
 would be nice to narrow my searching area.
>
> If you know anything about it, please let me know. Thanks, M.

Hi Michal,

Everything is in drivers/block/rbd.c.  The entry point is
rbd_queue_rq(), this is where all rbd requests are dispatched from.
After setting up where data is to be written from (for writes) or read
to (for reads), the details specific to each type of request (read,
write, discard or zeroout) are handled in __rbd_img_fill_request()
and then later on the respective state machine is kicked off.

The job of the state machine is to submit requests to the OSDs and
handle replies from the OSDs.  As in librbd, satisfying a single
user I/O request can require sending multiple OSDs requests, in some
cases sequentially.

Unfortunately, there is no one function to edit.  I might be able
to help more if you explain what you are trying to achieve.

Thanks,

                Ilya
