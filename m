Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1B736C90F
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhD0QI4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 12:08:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhD0QIz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619539692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IFEwSHwaj7Sjb744BtoYhwY+XvkkN3GWJzLSul6yy/c=;
        b=P4tyJw71+o1GE9N7xaj+Dfal8lJg7TFM7y9k8kwe7P617YALvAd9urqJv4YlbqBBDa02IC
        lvwNREbFlBAuoGGBa4hu+kEY6S3s31SZqIUTKZr41C3fuWYJYfHET/aAKjiKQ6OkvXzCCz
        o8gqKOCShb0DzPTMCz8r/xecU1xhUEI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-H45BJPbEM9-PYKVKj4nUkg-1; Tue, 27 Apr 2021 12:08:10 -0400
X-MC-Unique: H45BJPbEM9-PYKVKj4nUkg-1
Received: by mail-il1-f197.google.com with SMTP id l7-20020a9229070000b0290164314f61f5so30621275ilg.10
        for <ceph-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IFEwSHwaj7Sjb744BtoYhwY+XvkkN3GWJzLSul6yy/c=;
        b=fjkf80M9JCXM+ERx73OHgaKHQxLPykRlABuSEcnoggT09HHedRHpIVEkH4V24vg9RH
         V7FLN8lP490Xrr9WwIl5NrBxqooJ+Y6ZkN0oAeqY3CEsBupQ1C87i2FIMrGhOHzjnBO2
         yQh259kGoeLSCN+JjpBmZwq8j9T9YSJSIZngkb4Wa+XhZUfI3oG6niWt6j96vqY3Z9IL
         YFylpPbLE0p7KIe+NRdpoBAj3Qbo0rFz6BHbIukAjcu7dD6LfPQj5TPVocs5/oNkKQwR
         XHTVOKQNILF4j6rAz1wRxvuvYYMLxC1dJM75yNzmn5Wmu0dLrjVu5j0N9JkZPbd013yw
         uXkw==
X-Gm-Message-State: AOAM533WsSy479t+3CVV91QSBAPsHuGjogfBxqc5hVvLCzf6Plv2M/BB
        gLWlfTCTbV9NmRUaqUVWSMkHImP0t5th1eATuAfURYMV/NI32rIKpa5cYtmPF7sV9Mf1ROB6XXj
        Y6q70y0AttC7AKEFpxC/acX9vPAa5GO67tiH6WA==
X-Received: by 2002:a5d:8788:: with SMTP id f8mr20631725ion.7.1619539689466;
        Tue, 27 Apr 2021 09:08:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSqiEFlSsq4rndMkFwGaPCNHPuKAdClZ52oCXC/H645bYaPNKjVkw/lzFFxfNBiaPYokTNpHB5iAxkYtDW2uU=
X-Received: by 2002:a5d:8788:: with SMTP id f8mr20631709ion.7.1619539689278;
 Tue, 27 Apr 2021 09:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210426202759.20130-1-idryomov@gmail.com>
In-Reply-To: <20210426202759.20130-1-idryomov@gmail.com>
From:   Sage Weil <sweil@redhat.com>
Date:   Tue, 27 Apr 2021 11:07:58 -0500
Message-ID: <CAOQ2QO-DHPDTsAwdFpcpj4O2c8YTW-rqcnG7HcZEZ18x0Tm6Pw@mail.gmail.com>
Subject: Re: [PATCH] libceph: don't set global_id until we get an auth ticket
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 3:27 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> With the introduction of enforcing mode, setting global_id as soon
> as we get it in the first MAuth reply will result in EACCES if the
> connection is reset before we get the second MAuth reply containing
> an auth ticket -- because on retry we would attempt to reclaim that
> global_id with no auth ticket at hand.
>
> Neither ceph_auth_client nor ceph_mon_client depend on global_id
> being set ealy, so just delay the setting until we get and process
> the second MAuth reply.  While at it, complain if the monitor sends
> a zero global_id or changes our global_id as the session is likely
> to fail after that.
>
> Cc: stable@vger.kernel.org # needs backporting for < 5.11
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Sage Weil <sage@redhat.com>


> ---
>  net/ceph/auth.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> index eb261aa5fe18..de407e8feb97 100644
> --- a/net/ceph/auth.c
> +++ b/net/ceph/auth.c
> @@ -36,6 +36,20 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
>         }
>  }
>
> +static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> +{
> +       dout("%s global_id %llu\n", __func__, global_id);
> +
> +       if (!global_id)
> +               pr_err("got zero global_id\n");
> +
> +       if (ac->global_id && global_id != ac->global_id)
> +               pr_err("global_id changed from %llu to %llu\n", ac->global_id,
> +                      global_id);
> +
> +       ac->global_id = global_id;
> +}
> +
>  /*
>   * setup, teardown.
>   */
> @@ -222,11 +236,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>
>         payload_end = payload + payload_len;
>
> -       if (global_id && ac->global_id != global_id) {
> -               dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
> -               ac->global_id = global_id;
> -       }
> -
>         if (ac->negotiating) {
>                 /* server does not support our protocols? */
>                 if (!protocol && result < 0) {
> @@ -253,11 +262,16 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>
>         ret = ac->ops->handle_reply(ac, result, payload, payload_end,
>                                     NULL, NULL, NULL, NULL);
> -       if (ret == -EAGAIN)
> +       if (ret == -EAGAIN) {
>                 ret = build_request(ac, true, reply_buf, reply_len);
> -       else if (ret)
> +               goto out;
> +       } else if (ret) {
>                 pr_err("auth protocol '%s' mauth authentication failed: %d\n",
>                        ceph_auth_proto_name(ac->protocol), result);
> +               goto out;
> +       }
> +
> +       set_global_id(ac, global_id);
>
>  out:
>         mutex_unlock(&ac->mutex);
> @@ -484,15 +498,11 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
>         int ret;
>
>         mutex_lock(&ac->mutex);
> -       if (global_id && ac->global_id != global_id) {
> -               dout("%s global_id %llu -> %llu\n", __func__, ac->global_id,
> -                    global_id);
> -               ac->global_id = global_id;
> -       }
> -
>         ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
>                                     session_key, session_key_len,
>                                     con_secret, con_secret_len);
> +       if (!ret)
> +               set_global_id(ac, global_id);
>         mutex_unlock(&ac->mutex);
>         return ret;
>  }
> --
> 2.19.2
>

